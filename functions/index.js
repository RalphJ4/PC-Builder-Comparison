const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const cheerio = require("cheerio");

admin.initializeApp();
const db = admin.firestore();
const messaging = admin.messaging();

exports.scrapeStorePrices = functions
  .runWith({ timeoutSeconds: 300, memory: "512MB" })
  .pubsub.schedule("every 6 hours")
  .onRun(async () => {
    const components = await getWatchedComponents();
    for (const component of components) {
      await scrapeAndStore(component);
    }
    console.log(`Scraped prices for ${components.length} components`);
  });

async function getWatchedComponents() {
  const snapshot = await db.collectionGroup("watchlist").get();
  const seen = new Set();
  const components = [];
  snapshot.forEach((doc) => {
    const data = doc.data();
    if (!seen.has(data.componentId)) {
      seen.add(data.componentId);
      components.push(data);
    }
  });
  return components;
}

async function scrapeAndStore(component) {
  const query = encodeURIComponent(component.name);
  const results = await Promise.allSettled([
    scrapeShopee(query),
    scrapeLazada(query),
    scrapePCExpress(query),
    scrapeVillman(query),
  ]);

  const [shopeeR, lazadaR, pcExpressR, villmanR] = results;

  const newSnapshot = {
    shopee: shopeeR.status === "fulfilled" ? shopeeR.value : null,
    lazada: lazadaR.status === "fulfilled" ? lazadaR.value : null,
    pcExpress: pcExpressR.status === "fulfilled" ? pcExpressR.value : null,
    villman: villmanR.status === "fulfilled" ? villmanR.value : null,
    recordedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  const histRef = db
    .collection("price_history")
    .doc(component.componentId)
    .collection("snapshots");

  const prevSnap = await histRef.orderBy("recordedAt", "desc").limit(1).get();
  await histRef.add(newSnapshot);

  if (!prevSnap.empty) {
    const prev = prevSnap.docs[0].data();
    await checkAndAlert(component, prev, newSnapshot);
  }
}

async function scrapeShopee(query) {
  const url = `https://shopee.ph/api/v4/search/search_items?by=relevancy&keyword=${query}&limit=5&order=desc&page_type=search&scenario=PAGE_GLOBAL_SEARCH&version=2`;
  const { data } = await axios.get(url, {
    headers: {
      "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
      Referer: "https://shopee.ph/",
    },
    timeout: 10000,
  });

  const items = data?.items || [];
  if (!items.length) return null;

  const prices = items
    .map((i) => i.item_basic?.price / 100000)
    .filter((p) => p > 0)
    .sort((a, b) => a - b);

  return prices[0] || null;
}

async function scrapeLazada(query) {
  const url = `https://www.lazada.com.ph/catalog/?q=${query}&sort=priceasc`;
  const { data } = await axios.get(url, {
    headers: {
      "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15",
      Accept: "text/html",
    },
    timeout: 10000,
  });

  const $ = cheerio.load(data);
  const prices = [];

  $('[data-qa-locator="product-item"]').each((_, el) => {
    const priceText = $(el).find(".currency-symbol + span").text().trim();
    const price = parseFloat(priceText.replace(/[^0-9.]/g, ""));
    if (price > 0) prices.push(price);
  });

  if (!prices.length) {
    $('script[type="application/ld+json"]').each((_, el) => {
      try {
        const json = JSON.parse($(el).html());
        if (json.offers?.price) prices.push(parseFloat(json.offers.price));
      } catch (_) {}
    });
  }

  return prices.length ? Math.min(...prices) : null;
}

async function scrapePCExpress(query) {
  const url = `https://www.pcexpress.com.ph/search?q=${query}`;
  const { data } = await axios.get(url, {
    headers: { "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" },
    timeout: 10000,
  });

  const $ = cheerio.load(data);
  const prices = [];

  $(".price, .product-price, [class*='price']").each((_, el) => {
    const text = $(el).text().trim();
    const match = text.match(/[\d,]+(\.\d{2})?/);
    if (match) {
      const price = parseFloat(match[0].replace(/,/g, ""));
      if (price > 1000 && price < 500000) prices.push(price);
    }
  });

  return prices.length ? Math.min(...prices) : null;
}

async function scrapeVillman(query) {
  const url = `https://www.villman.com/Product-List/?q=${query}`;
  const { data } = await axios.get(url, {
    headers: { "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" },
    timeout: 10000,
  });

  const $ = cheerio.load(data);
  const prices = [];

  $(".price, .product_price, .item-price").each((_, el) => {
    const text = $(el).text().trim();
    const match = text.match(/[\d,]+(\.\d{2})?/);
    if (match) {
      const price = parseFloat(match[0].replace(/,/g, ""));
      if (price > 1000 && price < 500000) prices.push(price);
    }
  });

  return prices.length ? Math.min(...prices) : null;
}

async function checkAndAlert(component, prevSnap, newSnap) {
  const stores = ["shopee", "lazada", "pcExpress", "villman"];
  const storeNames = {
    shopee: "Shopee PH",
    lazada: "Lazada PH",
    pcExpress: "PC Express",
    villman: "Villman",
  };

  for (const store of stores) {
    const oldPrice = prevSnap[store];
    const newPrice = newSnap[store];
    if (!oldPrice || !newPrice) continue;

    const changePct = ((newPrice - oldPrice) / oldPrice) * 100;
    if (Math.abs(changePct) < 5) continue;

    const isSale = changePct < 0;
    const alertType = isSale ? "sale" : "hike";

    await db.collection("alerts").add({
      componentId: component.componentId,
      componentName: component.name,
      store: storeNames[store],
      oldPrice,
      newPrice,
      changePercent: Math.round(changePct * 10) / 10,
      type: alertType,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    await sendPushNotification(component.name, storeNames[store], oldPrice, newPrice, changePct, isSale);
    console.log(`Alert: ${component.name} on ${storeNames[store]} ${isSale ? "dropped" : "rose"} ${Math.abs(changePct).toFixed(1)}%`);
  }
}

async function sendPushNotification(name, store, oldPrice, newPrice, changePct, isSale) {
  const formatPrice = (p) => `₱${Math.round(p).toLocaleString("en-PH")}`;
  const pct = Math.abs(changePct).toFixed(0);

  const message = {
    topic: "price_alerts_ph",
    notification: {
      title: isSale ? `Price drop! ${name}` : `Price hike! ${name}`,
      body: isSale
        ? `${store}: ${formatPrice(oldPrice)} → ${formatPrice(newPrice)} (${pct}% off)`
        : `${store}: ${formatPrice(oldPrice)} → ${formatPrice(newPrice)} (up ${pct}%)`,
    },
    data: {
      type: isSale ? "sale" : "hike",
      componentName: name,
      store,
      oldPrice: String(oldPrice),
      newPrice: String(newPrice),
      changePercent: String(changePct),
      click_action: "FLUTTER_NOTIFICATION_CLICK",
    },
    android: {
      priority: "high",
      notification: {
        color: isSale ? "#00D97E" : "#FF8C42",
        channelId: "price_alerts",
      },
    },
    apns: {
      payload: {
        aps: { sound: "default", badge: 1 },
      },
    },
  };

  await messaging.send(message);
}

exports.scrapeComponent = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Login required");
  const { componentName, componentId } = data;
  await scrapeAndStore({ name: componentName, componentId });
  return { success: true };
});

const { GoogleGenerativeAI } = require("@google/generative-ai");

exports.generateBuild = functions.https.onCall(async (data, context) => {
  if (!context.auth) throw new functions.https.HttpsError("unauthenticated", "Login required");

  const { budget, useCase, priorities, peripherals } = data;
  const apiKey = functions.config().gemini.api_key || functions.config().google.ai_key;

  if (!apiKey) {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "Gemini API key not configured. Run: firebase functions:config:set gemini.api_key=\"YOUR_KEY\"\nGet a free key at https://aistudio.google.com/apikey"
    );
  }

  const genAI = new GoogleGenerativeAI(apiKey);
  const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

  const prompt = `You are a PC build expert for the Philippine market (2024-2025 prices).
Budget: ₱${budget}
Use case: ${useCase}
Priorities: ${priorities}
Peripherals: ${peripherals}

Recommend a complete PC build with realistic Philippine prices.
Reference Manila stores: PC Express, Villman, EasyPC, DataBlitz, Gilmore IT Center.
Compare against Shopee PH and Lazada PH.

Respond ONLY with valid JSON (no markdown, no extra text):
{
  "summary": "string",
  "totalMin": number,
  "totalMax": number,
  "estimatedSavings": number,
  "components": [
    {
      "id": "cpu",
      "category": "CPU",
      "name": "string",
      "why": "string",
      "prices": { "shopee": 0, "lazada": 0, "manila": 0, "manilaStore": "string" },
      "status": "sale|hike|normal",
      "statusNote": "string",
      "originalPrice": null
    }
  ]
}`;

  const result = await model.generateContent(prompt);
  const raw = result.response.text();
  const clean = raw.replace(/```json|```/g, "").trim();
  return JSON.parse(clean);
});
