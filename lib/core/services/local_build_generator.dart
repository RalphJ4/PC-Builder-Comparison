import '../models/pc_build.dart';
import '../models/pc_component.dart';
import '../models/price_snapshot.dart';

class LocalBuildGenerator {
  PcBuild generate(BuildConfig config) {
    final components = _buildComponents(config);
    final totalMin = components.fold<double>(0, (s, c) => s + c.prices.bestPrice);
    final totalMax = totalMin * (config.peripherals == 'Full setup' ? 1.10 : 1.12);
    final savings = components.fold<double>(
      0,
      (s, c) => s + ((c.originalPrice ?? c.prices.bestPrice) - c.prices.bestPrice),
    );

    return PcBuild(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      summary: _summary(config, components),
      totalMin: totalMin,
      totalMax: totalMax,
      estimatedSavings: savings,
      components: components,
      config: config,
    );
  }

  String _summary(BuildConfig config, List<PcComponent> comps) {
    final cpu = comps.firstWhere((c) => c.category == 'CPU', orElse: () => comps.first);
    final gpu = comps.where((c) => c.category == 'GPU').isNotEmpty
        ? comps.firstWhere((c) => c.category == 'GPU')
        : null;
    final ram = comps.firstWhere((c) => c.category == 'RAM', orElse: () => comps.first);
    final gpuText = gpu != null ? '${gpu.name}, ' : 'integrated graphics, ';
    return '${config.useCase} build — ${cpu.name}, $gpuText${ram.name}. '
        '₱${config.budget.toStringAsFixed(0)} budget optimized for '
        '${config.priorities.join(", ").toLowerCase()}.';
  }

  List<PcComponent> _buildComponents(BuildConfig config) {
    final budget = config.budget;
    final useCase = config.useCase;
    final priorities = config.priorities;
    final storePref = config.stores;
    final isBestValue = priorities.contains('Best value');
    final isFutureProof = priorities.contains('Future-proof');
    final isHighFps = priorities.contains('High FPS');
    final isSilent = priorities.contains('Silent/cool');
    final isCompact = priorities.contains('Compact');

    List<PcComponent> parts;

    if (budget <= 25000) {
      parts = _build25k(useCase, isBestValue, isFutureProof, isSilent, isCompact);
    } else if (budget <= 40000) {
      parts = _build40k(useCase, isBestValue, isFutureProof, isHighFps, isSilent, isCompact);
    } else if (budget <= 65000) {
      parts = _build65k(useCase, isBestValue, isFutureProof, isHighFps, isSilent, isCompact);
    } else if (budget <= 90000) {
      parts = _build90k(useCase, isBestValue, isFutureProof, isHighFps, isSilent, isCompact);
    } else {
      parts = _build100k(useCase, isBestValue, isFutureProof, isHighFps, isSilent, isCompact);
    }

    if (config.peripherals != 'PC only') {
      parts.addAll(_peripherals(config.peripherals == 'Full setup', useCase, budget, isBestValue));
    }

    if (storePref == 'Manila stores') {
      parts = parts.map((c) {
        final m = c.prices.manila ?? c.prices.bestPrice;
        return PcComponent(
          id: c.id, category: c.category, name: c.name, why: c.why,
          prices: PriceSnapshot(manila: m, manilaStoreName: c.prices.manilaStoreName),
          status: c.status, statusNote: c.statusNote, originalPrice: c.originalPrice,
        );
      }).toList();
    } else if (storePref == 'Online only') {
      parts = parts.map((c) {
        final s = c.prices.shopee ?? c.prices.bestPrice;
        final l = c.prices.lazada ?? c.prices.bestPrice;
        return PcComponent(
          id: c.id, category: c.category, name: c.name, why: c.why,
          prices: PriceSnapshot(shopee: s, lazada: l),
          status: c.status, statusNote: c.statusNote, originalPrice: c.originalPrice,
        );
      }).toList();
    }

    return parts;
  }

  List<PcComponent> _peripherals(bool fullSetup, String useCase, double budget, bool bestValue) {
    final isGaming = useCase == 'Gaming' || useCase == 'Streaming';
    final highBudget = budget >= 65000;
    final list = <PcComponent>[];

    if (highBudget || isGaming) {
      list.add(_part('mon_g', 'Monitor', isGaming
          ? 'AOC 24G2SP 24" 165Hz IPS Gaming Monitor'
          : 'Dell S2722QC 27" 4K IPS Monitor',
          'High-refresh gaming monitor / 4K productivity', 10500, 11000, 10000,
          store: 'DataBlitz'));
    } else {
      list.add(_part('mon_b', 'Monitor', 'ViewSonic VA2432-H 24" IPS',
          'Affordable IPS panel for daily use', 5500, 5800, 5300));
    }

    if (fullSetup) {
      if (isGaming) {
        list.add(_part('kb1', 'Keyboard', 'Redragon K552 Kumara Mechanical',
            'Budget mechanical with blue switches', 1400, 1600, 1300, store: 'EasyPC'));
        list.add(_part('ms1', 'Mouse', 'Logitech G304 Lightspeed Wireless',
            'Best budget wireless gaming mouse', 1600, 1800, 1500));
        list.add(_part('hs1', 'Headset', 'HyperX Cloud Stinger 2',
            'Comfortable budget gaming headset', 2400, 2600, 2300));
      } else {
        list.add(_part('kb2', 'Keyboard', 'Logitech MK270 Wireless Combo',
            'Reliable wireless keyboard + mouse combo', 1200, 1400, 1100));
        list.add(_part('ms2', 'Mouse', 'Logitech M190 Wireless Mouse',
            'Ergonomic wireless mouse', 700, 800, 650));
        list.add(_part('hs2', 'Headset', 'Jabra Evolve 20 SE',
            'Office headset with mic', 2500, 2700, 2400));
      }
    }
    return list;
  }

  // ─── ₱25K ────────────────────────────────────────────────────────
  List<PcComponent> _build25k(String use, bool value, bool future, bool silent, bool compact) {
    final isGaming = use == 'Gaming' || use == 'Streaming';
    final isContent = use == 'Content Creation';
    if (isGaming) return [
      _part('cpu', 'CPU', 'AMD Ryzen 5 5600G', 'APU with Vega 7 graphics — 1080p esports ready',
          5200, 5500, 5100, store: 'EasyPC', note: 'Best budget APU, no GPU needed'),
      _part('mb', 'Motherboard', 'Gigabyte B450M DS3H V3', 'Reliable AM4, PCIe 3.0',
          3400, 3600, 3300),
      _part('ram', 'RAM', 'TeamGroup T-Force Vulcan 16GB (2x8) DDR4 3200',
          'Dual-channel for max iGPU performance', 2100, 2300, 2000, store: 'DataBlitz'),
      _part('st', 'Storage', 'Kingston NV2 500GB NVMe SSD', 'Fast Gen4 NVMe boot drive',
          2500, 2700, 2400),
      _part('psu', 'PSU', 'Cooler Master MWE 550W 80+ Bronze', 'Plenty for APU build',
          2600, 2800, 2500),
      _part('case', 'Case', compact ? 'Tecware Flatline (3 fans)' : 'Tecware Forge M (4 fans)',
          compact ? 'Compact mATX with good airflow' : 'Mesh front, great airflow',
          1800, 2000, 1700, store: 'EasyPC'),
    ];

    if (isContent || use == 'Office/Study') return [
      _part('cpu', 'CPU', 'Intel Core i3-12100F', 'Fast single-core for apps',
          4200, 4500, 4100),
      _part('mb', 'Motherboard', 'MSI PRO B660M-G DDR4', 'LGA1700 with solid VRMs',
          4100, 4300, 4000),
      _part('ram', 'RAM', 'Kingston Fury Beast 16GB DDR4 3200',
          isContent ? '16GB enough for light editing' : 'Standard for office tasks',
          2200, 2400, 2100),
      _part('st', 'Storage', 'Samsung 870 EVO 500GB SATA SSD', 'Reliable SATA storage',
          2800, 3000, 2700),
      _part('psu', 'PSU', 'FSP HV Pro 550W 80+', 'Budget reliable PSU',
          2000, 2200, 1900),
      _part('case', 'Case', 'DarkFlash DLM21 Mesh', 'Compact mesh case',
          1600, 1800, 1500),
    ];

    return [
      _part('cpu', 'CPU', 'Intel Core i3-12100', 'Great for daily programming',
          4700, 5000, 4600),
      _part('mb', 'Motherboard', 'Gigabyte H610M H', 'Budget LGA1700 board',
          3500, 3700, 3400),
      _part('ram', 'RAM', 'TeamGroup 16GB DDR4 3200', 'Standard RAM for dev work',
          2000, 2200, 1900),
      _part('st', 'Storage', 'WD Blue SN570 500GB NVMe', 'Fast NVMe for code',
          2500, 2700, 2400),
      _part('psu', 'PSU', 'FSP HV Pro 550W 80+', 'Reliable PSU',
          2000, 2200, 1900),
      _part('case', 'Case', 'DarkFlash DLM21 Mesh', 'Compact mesh case',
          1600, 1800, 1500),
    ];
  }

  // ─── ₱40K ────────────────────────────────────────────────────────
  List<PcComponent> _build40k(String use, bool value, bool future, bool fps, bool silent, bool compact) {
    final isGaming = use == 'Gaming' || use == 'Streaming';
    final isContent = use == 'Content Creation';

    if (isGaming) return [
      _part('cpu', 'CPU', value ? 'AMD Ryzen 5 5600' : 'Intel Core i5-12400F',
          'Best value gaming CPU in 2024', 6200, 6500, 6000, store: 'PC Express'),
      _part('mb', 'Motherboard', 'MSI B550M PRO-VDH WiFi', 'AM4 WiFi, PCIe 4.0',
          5200, 5500, 5000),
      _part('gpu', 'GPU', 'Radeon RX 6600 8GB', '1080p max settings — best value GPU',
          12500, 13000, 12000, store: 'EasyPC',
          note: 'Shopee flash sales drop to ₱11,500'),
      _part('ram', 'RAM', 'G.Skill Ripjaws V 16GB DDR4 3600', 'Fast RAM for Ryzen',
          2500, 2700, 2400),
      _part('st', 'Storage', 'ADATA XPG SX8200 Pro 1TB NVMe', 'Fast 1TB Gen3 NVMe',
          3500, 3700, 3400),
      _part('psu', 'PSU', 'Seasonic S12III 550W 80+ Bronze', 'Trusted PSU brand',
          2900, 3100, 2800),
      _part('case', 'Case', compact ? 'Tecware Forge M (4 fans)' : 'Lian Li LANCOOL 205M',
          compact ? 'Compact mATX, great airflow' : 'Premium mATX chassis',
          2200, 2400, 2100),
    ];

    if (isContent) return [
      _part('cpu', 'CPU', 'Intel Core i5-12400F', 'Best value productivity CPU',
          7200, 7500, 7000),
      _part('mb', 'Motherboard', 'ASUS Prime B660M-A D4', 'Solid LGA1700 with good VRMs',
          5200, 5500, 5000),
      _part('gpu', 'GPU', 'NVIDIA GTX 1650 4GB', 'Entry GPU for light rendering',
          7500, 8000, 7200),
      _part('ram', 'RAM', 'TeamGroup 32GB (2x16) DDR4 3200', '32GB for content work',
          3800, 4000, 3600),
      _part('st', 'Storage', 'Samsung 980 1TB NVMe', 'Fast Gen3 NVMe',
          4500, 4800, 4300),
      _part('psu', 'PSU', 'Cooler Master MWE 550W 80+ Bronze', 'Reliable 550W',
          2600, 2800, 2500),
      _part('case', 'Case', 'Fractal Design Focus G', 'Clean, silent, good airflow',
          3200, 3500, 3000),
    ];

    if (use == 'Programming') return [
      _part('cpu', 'CPU', 'Intel Core i5-12400', '6P+4E cores for fast compiles',
          8200, 8500, 8000),
      _part('mb', 'Motherboard', 'Gigabyte B760M DS3H AX', 'WiFi 6, DDR5 ready',
          6200, 6500, 6000),
      _part('ram', 'RAM', 'Kingston Fury Beast 32GB DDR5 4800', '32GB fast DDR5 for dev',
          4200, 4500, 4000),
      _part('st', 'Storage', 'WD Blue SN570 1TB NVMe', 'Fast NVMe for code',
          3800, 4000, 3600),
      _part('psu', 'PSU', 'FSP Hydro GD 550W 80+ Gold', 'Gold efficiency, reliable',
          3200, 3400, 3000),
      _part('case', 'Case', 'NZXT H510 Flow', 'Clean, professional look',
          3800, 4000, 3600),
    ];

    return [
      _part('cpu', 'CPU', 'Intel Core i5-12400', 'Excellent multitasking CPU',
          8200, 8500, 8000),
      _part('mb', 'Motherboard', 'Gigabyte B760M DS3H AX', 'WiFi + modern features',
          6200, 6500, 6000),
      _part('ram', 'RAM', 'Kingston Fury Beast 16GB DDR5 4800', 'DDR5 ready',
          3200, 3400, 3000),
      _part('st', 'Storage', 'WD Blue SN570 1TB NVMe', 'Fast reliable storage',
          3800, 4000, 3600),
      _part('psu', 'PSU', 'FSP Hydro GD 550W 80+ Gold', 'Gold efficiency',
          3200, 3400, 3000),
      _part('case', 'Case', 'NZXT H510 Flow', 'Premium clean case',
          3800, 4000, 3600),
    ];
  }

  // ─── ₱65K ────────────────────────────────────────────────────────
  List<PcComponent> _build65k(String use, bool value, bool future, bool fps, bool silent, bool compact) {
    final isGaming = use == 'Gaming' || use == 'Streaming';
    final isContent = use == 'Content Creation';

    if (isGaming) return [
      _part('cpu', 'CPU', future ? 'AMD Ryzen 5 7500F' : 'AMD Ryzen 5 5600X3D',
          future ? 'AM5 platform, upgrade path' : 'AM4, best gaming value',
          9500, 9800, 9200, store: 'EasyPC'),
      _part('mb', 'Motherboard', future ? 'ASRock B650M PG Riptide' : 'MSI B550M PRO-VDH WiFi',
          future ? 'AM5 DDR5 board' : 'AM4 with WiFi',
          7200, 7500, 7000),
      _part('gpu', 'GPU', 'Radeon RX 7700 XT 12GB', '1440p gaming — excellent value',
          24500, 25500, 24000, store: 'PC Express'),
      _part('ram', 'RAM', future ? 'G.Skill Flare X5 32GB DDR5 6000' : 'G.Skill Ripjaws V 16GB DDR4 3600',
          future ? 'AM5 sweet spot RAM' : 'Fast DDR4 kit',
          future ? 5500 : 2500, future ? 5800 : 2700, future ? 5300 : 2400),
      _part('st', 'Storage', 'Samsung 990 Pro 1TB NVMe', 'Top-tier Gen4 SSD',
          6500, 6800, 6300),
      _part('psu', 'PSU', 'Corsair RM750e 750W 80+ Gold', 'Fully modular, efficient',
          5500, 5800, 5300),
      _part('case', 'Case', compact ? 'Lian Li LANCOOL 205M' : 'Lian Li LANCOOL 216',
          compact ? 'Compact but great airflow' : 'Excellent airflow, comes with fans',
          compact ? 3500 : 4200, compact ? 3800 : 4500, compact ? 3300 : 4000),
    ];

    if (isContent) return [
      _part('cpu', 'CPU', 'Intel Core i5-13600KF', 'Strong multi-core for editing',
          12500, 13000, 12000),
      _part('mb', 'Motherboard', 'MSI MAG Z790 TOMAHAWK WiFi', 'Great OC support',
          13500, 14000, 13000),
      _part('gpu', 'GPU', 'NVIDIA RTX 4060 8GB', 'Good for CUDA rendering',
          18500, 19500, 18000),
      _part('ram', 'RAM', 'Corsair Vengeance 32GB DDR5 5600', 'Solid DDR5 kit',
          5800, 6000, 5500),
      _part('st', 'Storage', 'WD Black SN850X 2TB NVMe', 'Fast 2TB scratch drive',
          9500, 10000, 9200),
      _part('psu', 'PSU', 'Seasonic FOCUS GX-750 80+ Gold', 'Top reliability',
          6200, 6500, 6000),
      _part('case', 'Case', 'Corsair 4000D Airflow', 'Clean, great airflow',
          4800, 5000, 4600),
    ];

    return [
      _part('cpu', 'CPU', 'Intel Core i5-13500', '14-core productivity king',
          13500, 14000, 13000),
      _part('mb', 'Motherboard', 'ASUS TUF B760-PLUS WiFi', 'Durable WiFi board',
          8500, 8800, 8200),
      _part('ram', 'RAM', 'Kingston Fury Beast 32GB DDR5 5200', 'Future-proof RAM',
          5200, 5500, 5000),
      _part('st', 'Storage', 'Samsung 870 EVO 2TB SATA SSD', 'Ample storage',
          7500, 7800, 7200),
      _part('psu', 'PSU', silent ? 'be quiet! Pure Power 11 600W' : 'Corsair RM750e 750W',
          silent ? 'Super quiet PSU' : 'Efficient modular PSU',
          silent ? 4200 : 5500, silent ? 4500 : 5800, silent ? 4000 : 5300),
      _part('case', 'Case', silent ? 'be quiet! Pure Base 500DX' : 'NZXT H5 Flow',
          silent ? 'Silent premium case' : 'Great airflow',
          silent ? 5200 : 5500, silent ? 5500 : 5800, silent ? 5000 : 5200),
    ];
  }

  // ─── ₱90K ────────────────────────────────────────────────────────
  List<PcComponent> _build90k(String use, bool value, bool future, bool fps, bool silent, bool compact) {
    final isGaming = use == 'Gaming' || use == 'Streaming';
    final isContent = use == 'Content Creation';

    if (isGaming) return [
      _part('cpu', 'CPU', 'AMD Ryzen 7 7800X3D', 'Best gaming CPU on the market',
          18500, 19500, 18000, store: 'PC Express'),
      _part('mb', 'Motherboard', 'Gigabyte B650 AORUS Elite AX', 'Premium AM5 VRMs',
          9500, 9800, 9200),
      _part('gpu', 'GPU', fps ? 'Radeon RX 7900 GRE 16GB' : 'NVIDIA RTX 4070 12GB',
          fps ? '1440p ultra, high FPS' : 'Ray tracing + DLSS 3',
          32000, 33500, 31000, store: 'EasyPC'),
      _part('ram', 'RAM', 'G.Skill Trident Z5 Neo 32GB DDR5 6000 CL30', 'Optimal for X3D',
          7500, 7800, 7200),
      _part('st', 'Storage', 'Samsung 990 Pro 2TB NVMe', 'Blazing fast 2TB Gen4',
          9500, 10000, 9200),
      _part('psu', 'PSU', 'Corsair RM850x 850W 80+ Gold', 'High-end reliable PSU',
          7500, 7800, 7200),
      _part('case', 'Case', compact ? 'NZXT H5 Flow' : 'NZXT H7 Flow',
          compact ? 'Compact ATX with great airflow' : 'Premium airflow case',
          compact ? 5500 : 6500, compact ? 5800 : 6800, compact ? 5200 : 6200),
    ];

    if (isContent) return [
      _part('cpu', 'CPU', 'Intel Core i7-13700K', 'Excellent for video editing + rendering',
          18500, 19500, 18000),
      _part('mb', 'Motherboard', 'MSI MPG Z790 EDGE WiFi', 'High-end editing workstation',
          16500, 17500, 16000),
      _part('gpu', 'GPU', 'NVIDIA RTX 4070 12GB', 'Great for rendering + AI',
          28500, 29500, 28000),
      _part('ram', 'RAM', 'Corsair Dominator 64GB DDR5 5600', 'Max RAM for heavy editing',
          12000, 12500, 11500),
      _part('st', 'Storage', 'WD Black SN850X 2TB NVMe', 'Fast scratch drive',
          9500, 10000, 9200),
      _part('psu', 'PSU', 'Seasonic PRIME TX-850 80+ Titanium', 'Best efficiency',
          9500, 10000, 9200),
      _part('case', 'Case', 'Fractal Design Meshify 2', 'Workstation-class case',
          7500, 7800, 7200),
    ];

    return [
      _part('cpu', 'CPU', 'Intel Core i7-13700', '16-core office powerhouse',
          17500, 18500, 17000),
      _part('mb', 'Motherboard', 'ASUS ProArt B760-CREATOR', 'Professional workstation board',
          9500, 9800, 9200),
      _part('gpu', 'GPU', 'NVIDIA RTX 3050 6GB', 'Multi-monitor support',
          9500, 10000, 9200),
      _part('ram', 'RAM', 'Kingston Fury Beast 32GB DDR5 5600', 'Reliable high-speed RAM',
          5500, 5800, 5300),
      _part('st', 'Storage', 'Samsung 990 Pro 1TB NVMe', 'Fast boot + apps',
          6500, 6800, 6300),
      _part('st2', 'Storage', 'Samsung 870 EVO 4TB SATA SSD', 'Massive file storage',
          13500, 14000, 13000),
      _part('psu', 'PSU', silent ? 'be quiet! Dark Power 13 850W' : 'Corsair RM750x 750W',
          silent ? 'Silent premium PSU' : 'Premium reliability',
          silent ? 10500 : 6500, silent ? 11000 : 6800, silent ? 10000 : 6200),
      _part('case', 'Case', silent ? 'Fractal Design Define 7' : 'Fractal Design Meshify 2',
          silent ? 'Silent workstation' : 'Airflow-optimized',
          silent ? 8500 : 7500, silent ? 8800 : 7800, silent ? 8200 : 7200),
    ];
  }

  // ─── ₱100K+ ──────────────────────────────────────────────────────
  List<PcComponent> _build100k(String use, bool value, bool future, bool fps, bool silent, bool compact) {
    final isGaming = use == 'Gaming' || use == 'Streaming';
    final isContent = use == 'Content Creation';

    if (isGaming) return [
      _part('cpu', 'CPU', 'AMD Ryzen 7 7800X3D', 'Best gaming CPU period',
          18500, 19500, 18000),
      _part('mb', 'Motherboard', 'ASUS ROG STRIX X670E-E Gaming', 'Top-tier AM5 board',
          18500, 19500, 18000),
      _part('gpu', 'GPU', fps
          ? 'Radeon RX 7900 XTX 24GB'
          : 'NVIDIA RTX 4070 Ti Super 16GB',
          fps ? '1440p/4K ultra high FPS' : '4K gaming + ray tracing + DLSS',
          fps ? 48000 : 42000, fps ? 50000 : 44000, fps ? 47000 : 41000,
          store: 'EasyPC', note: 'Commonly on sale during Shopee Mega Flash Sales'),
      _part('ram', 'RAM', 'G.Skill Trident Z5 Neo 32GB DDR5 6000 CL30', 'Perfect X3D RAM',
          7500, 7800, 7200),
      _part('st', 'Storage', 'Samsung 990 Pro 2TB NVMe', 'Primary drive',
          9500, 10000, 9200),
      _part('st2', 'Storage', 'WD Black SN850X 2TB NVMe', 'Game storage',
          9500, 10000, 9200),
      _part('psu', 'PSU', 'Corsair RM1000x 1000W 80+ Gold', 'Future-proof 1000W',
          9500, 10000, 9200),
      _part('case', 'Case', 'Lian Li O11 Dynamic EVO', 'Showcase build case',
          8500, 8800, 8200),
      _part('cool', 'Cooler', 'NZXT Kraken X73 360mm AIO', 'Top-tier AIO cooling',
          9500, 10000, 9200),
    ];

    if (isContent) return [
      _part('cpu', 'CPU', 'Intel Core i9-13900K', 'Top productivity CPU',
          22500, 23500, 22000),
      _part('mb', 'Motherboard', 'ASUS ROG MAXIMUS Z790 HERO', 'Best for i9 OC',
          22500, 23500, 22000),
      _part('gpu', 'GPU', 'NVIDIA RTX 4080 Super 16GB', 'Professional rendering + AI',
          55000, 58000, 54000, store: 'PC Express'),
      _part('ram', 'RAM', 'Corsair Dominator 64GB DDR5 6000', 'Heavy editing RAM',
          14500, 15000, 14000),
      _part('st', 'Storage', 'Samsung 990 Pro 2TB NVMe', 'OS + projects',
          9500, 10000, 9200),
      _part('st2', 'Storage', 'Samsung 870 EVO 4TB SATA SSD', 'Archive storage',
          13500, 14000, 13000),
      _part('psu', 'PSU', 'Seasonic PRIME PX-1000 80+ Platinum', 'Premium platinum',
          12500, 13000, 12000),
      _part('case', 'Case', 'Fractal Design Meshify 2 XL', 'Full-tower workstation',
          9500, 10000, 9200),
      _part('cool', 'Cooler', 'Arctic Liquid Freezer III 420', 'Massive AIO cooling',
          7500, 7800, 7200),
    ];

    return [
      _part('cpu', 'CPU', 'Intel Core i9-13900', 'Office multitasking beast',
          21500, 22500, 21000),
      _part('mb', 'Motherboard', 'MSI MEG Z790 ACE', 'Top-tier workstation board',
          18500, 19500, 18000),
      _part('gpu', 'GPU', 'NVIDIA RTX 4060 8GB', 'Multi-monitor + CUDA',
          18000, 19000, 17500),
      _part('ram', 'RAM', 'Kingston Fury Beast 64GB DDR5 5600', 'Massive office RAM',
          11500, 12000, 11000),
      _part('st', 'Storage', 'Samsung 990 Pro 2TB NVMe', 'Primary drive',
          9500, 10000, 9200),
      _part('st2', 'Storage', 'Samsung 870 EVO 4TB SATA SSD', 'File storage',
          13500, 14000, 13000),
      _part('st3', 'Storage', 'Seagate Barracuda 8TB HDD', 'Cold storage archive',
          7000, 7500, 6800),
      _part('psu', 'PSU', silent ? 'be quiet! Dark Power 13 850W' : 'Corsair RM1000x 1000W',
          silent ? 'Silent premium' : 'Future-proof 1000W',
          silent ? 8500 : 9500, silent ? 8800 : 10000, silent ? 8200 : 9200),
      _part('case', 'Case', silent ? 'Fractal Design Define 7 XL' : 'Fractal Design Meshify 2 XL',
          silent ? 'Max storage, silent' : 'Max airflow XL',
          silent ? 10500 : 9500, silent ? 11000 : 10000, silent ? 10000 : 9200),
    ];
  }

  PcComponent _part(String id, String cat, String name, String why,
      double shopee, double lazada, double manila,
      {String store = 'PC Express', String? note, double? orig}) {
    return PcComponent(
      id: id,
      category: cat,
      name: name,
      why: why,
      prices: PriceSnapshot(
        shopee: shopee,
        lazada: lazada,
        manila: manila,
        manilaStoreName: store,
      ),
      status: PriceStatus.normal,
      statusNote: note ?? '',
      originalPrice: orig,
    );
  }
}
