class LocalMockData {
  static List<Map<String, dynamic>> getComponents() => [
    // ─── CPUs (20) ───────────────────────────────────────────────
    ..._cpus,
    // ─── GPUs (15) ───────────────────────────────────────────────
    ..._gpus,
    // ─── RAM (12) ────────────────────────────────────────────────
    ..._rams,
    // ─── Motherboards (12) ────────────────────────────────────────
    ..._mbs,
    // ─── Storage (12) ─────────────────────────────────────────────
    ..._storages,
    // ─── PSUs (10) ────────────────────────────────────────────────
    ..._psus,
    // ─── Cases (10) ───────────────────────────────────────────────
    ..._cases,
    // ─── Coolers (8) ──────────────────────────────────────────────
    ..._coolers,
    // ─── Monitors (10) ────────────────────────────────────────────
    ..._monitors,
    // ─── Peripherals (12) ─────────────────────────────────────────
    ..._peripherals,
  ];

  static final _cpus = [
    _c('cpu_5600', 'AMD Ryzen 5 5600', 'sale', 6200, 6500, 6000, 'PC Express'),
    _c('cpu_5600g', 'AMD Ryzen 5 5600G', 'normal', 5200, 5500, 5100, 'EasyPC'),
    _c('cpu_5600x', 'AMD Ryzen 5 5600X', 'hike', 7800, 8200, 7600, 'PC Express'),
    _c('cpu_5700x', 'AMD Ryzen 7 5700X', 'normal', 9500, 9900, 9200, 'EasyPC'),
    _c('cpu_5800x', 'AMD Ryzen 7 5800X', 'sale', 11500, 12000, 11000, 'PC Express'),
    _c('cpu_7500f', 'AMD Ryzen 5 7500F', 'normal', 9500, 9800, 9200, 'EasyPC'),
    _c('cpu_7600', 'AMD Ryzen 5 7600', 'normal', 12500, 13000, 12000),
    _c('cpu_7600x', 'AMD Ryzen 5 7600X', 'hike', 14500, 15000, 14000, 'PC Express'),
    _c('cpu_7700', 'AMD Ryzen 7 7700', 'normal', 16500, 17200, 16000),
    _c('cpu_7800x3d', 'AMD Ryzen 7 7800X3D', 'normal', 18500, 19500, 18000, 'PC Express'),
    _c('cpu_7950x', 'AMD Ryzen 9 7950X', 'sale', 28500, 29500, 27500, 'EasyPC'),
    _c('cpu_i3_12100', 'Intel Core i3-12100', 'normal', 4700, 5000, 4600),
    _c('cpu_i3_12100f', 'Intel Core i3-12100F', 'sale', 4200, 4500, 4100),
    _c('cpu_i5_12400', 'Intel Core i5-12400', 'normal', 8200, 8500, 8000),
    _c('cpu_i5_12400f', 'Intel Core i5-12400F', 'hike', 7200, 7500, 7000),
    _c('cpu_i5_13400', 'Intel Core i5-13400', 'normal', 11500, 12000, 11200, 'DataBlitz'),
    _c('cpu_i5_13600k', 'Intel Core i5-13600KF', 'hike', 12500, 13000, 12800, 'DataBlitz'),
    _c('cpu_i7_13700', 'Intel Core i7-13700', 'normal', 17500, 18500, 17000),
    _c('cpu_i7_13700k', 'Intel Core i7-13700K', 'sale', 18500, 19500, 18000, 'PC Express'),
    _c('cpu_i9_13900k', 'Intel Core i9-13900K', 'normal', 22500, 23500, 22000),
  ];

  static final _gpus = [
    _c('gpu_rx6600', 'Radeon RX 6600 8GB', 'sale', 11500, 13000, 12000, 'EasyPC'),
    _c('gpu_rx6600xt', 'Radeon RX 6600 XT 8GB', 'normal', 14500, 15500, 14000),
    _c('gpu_rx6650xt', 'Radeon RX 6650 XT 8GB', 'sale', 15500, 16500, 15000, 'PC Express'),
    _c('gpu_rx6700xt', 'Radeon RX 6700 XT 12GB', 'normal', 19500, 20500, 19000),
    _c('gpu_rx7600', 'Radeon RX 7600 8GB', 'normal', 16500, 17500, 16000, 'EasyPC'),
    _c('gpu_rx7700xt', 'Radeon RX 7700 XT 12GB', 'normal', 24500, 25500, 24000, 'PC Express'),
    _c('gpu_rx7800xt', 'Radeon RX 7800 XT 16GB', 'sale', 28500, 29500, 27500),
    _c('gpu_rx7900gre', 'Radeon RX 7900 GRE 16GB', 'normal', 32000, 33500, 31000, 'EasyPC'),
    _c('gpu_rx7900xtx', 'Radeon RX 7900 XTX 24GB', 'hike', 48000, 50000, 47000),
    _c('gpu_rtx3050', 'NVIDIA RTX 3050 6GB', 'normal', 9500, 10000, 9200),
    _c('gpu_rtx4060', 'NVIDIA RTX 4060 8GB', 'normal', 18500, 19500, 18000),
    _c('gpu_rtx4060ti', 'NVIDIA RTX 4060 Ti 8GB', 'sale', 22500, 23500, 21500, 'DataBlitz'),
    _c('gpu_rtx4070', 'NVIDIA RTX 4070 12GB', 'normal', 28500, 29500, 28000),
    _c('gpu_rtx4070tis', 'NVIDIA RTX 4070 Ti Super 16GB', 'hike', 42000, 44000, 42500, 'EasyPC'),
    _c('gpu_rtx4080s', 'NVIDIA RTX 4080 Super 16GB', 'normal', 55000, 58000, 54000, 'PC Express'),
  ];

  static final _rams = [
    _c('ram_ddr4_8', 'TeamGroup 8GB DDR4 3200', 'normal', 1100, 1200, 1050),
    _c('ram_ddr4_16', 'G.Skill Ripjaws V 16GB DDR4 3600', 'sale', 2200, 2700, 2400, 'DataBlitz'),
    _c('ram_ddr4_32', 'Corsair Vengeance 32GB DDR4 3200', 'normal', 3800, 4000, 3600),
    _c('ram_ddr4_32rgb', 'TeamGroup T-Force Delta 32GB DDR4 3600 RGB', 'sale', 4200, 4500, 4000),
    _c('ram_ddr4_64', 'G.Skill Trident Z 64GB DDR4 3600', 'normal', 8500, 8800, 8200),
    _c('ram_ddr5_16', 'Kingston Fury Beast 16GB DDR5 5200', 'normal', 2800, 3000, 2700),
    _c('ram_ddr5_32', 'G.Skill Flare X5 32GB DDR5 6000', 'normal', 5500, 5800, 5300),
    _c('ram_ddr5_32rgb', 'Corsair Vengeance RGB 32GB DDR5 6000', 'sale', 6500, 6800, 6200, 'DataBlitz'),
    _c('ram_ddr5_64', 'Corsair Dominator 64GB DDR5 5600', 'normal', 12000, 12500, 11500),
    _c('ram_ddr5_64rgb', 'G.Skill Trident Z5 RGB 64GB DDR5 6000', 'hike', 14500, 15000, 14000),
    _c('ram_ddr5_128', 'Kingston Fury 128GB DDR5 4800', 'normal', 22500, 23500, 21500),
    _c('ram_ddr5_32cl30', 'G.Skill Trident Z5 Neo 32GB DDR5 6000 CL30', 'normal', 7500, 7800, 7200),
  ];

  static final _mbs = [
    _c('mb_a320', 'Gigabyte A320M-H', 'normal', 2500, 2700, 2400),
    _c('mb_b450', 'MSI B450M PRO-VDH Max', 'normal', 3800, 4000, 3600),
    _c('mb_b550', 'MSI B550M PRO-VDH WiFi', 'sale', 5200, 5500, 5000, 'PC Express'),
    _c('mb_b550_aorus', 'Gigabyte B550 AORUS Elite V2', 'normal', 6200, 6500, 6000),
    _c('mb_b650', 'ASRock B650M PG Riptide', 'normal', 7200, 7500, 7000, 'EasyPC'),
    _c('mb_b650_aorus', 'Gigabyte B650 AORUS Elite AX', 'hike', 9500, 9800, 9200),
    _c('mb_x670e', 'ASUS ROG STRIX X670E-E', 'normal', 18500, 19500, 18000),
    _c('mb_b660', 'MSI PRO B660M-G DDR4', 'normal', 4100, 4300, 4000),
    _c('mb_b760', 'Gigabyte B760M DS3H AX', 'sale', 6200, 6500, 6000, 'DataBlitz'),
    _c('mb_z790', 'MSI MPG Z790 EDGE WiFi', 'normal', 16500, 17500, 16000),
    _c('mb_z790_aorus', 'Gigabyte Z790 AORUS Master', 'normal', 22500, 23500, 21500),
    _c('mb_b760_proart', 'ASUS ProArt B760-CREATOR', 'normal', 9500, 9800, 9200),
  ];

  static final _storages = [
    _c('st_nv2_500', 'Kingston NV2 500GB NVMe', 'normal', 2500, 2700, 2400),
    _c('st_nv2_1tb', 'Kingston NV2 1TB NVMe', 'sale', 3500, 3700, 3400, 'EasyPC'),
    _c('st_sn570_500', 'WD Blue SN570 500GB NVMe', 'normal', 2500, 2700, 2400),
    _c('st_sn570_1tb', 'WD Blue SN570 1TB NVMe', 'normal', 3800, 4000, 3600),
    _c('st_980_1tb', 'Samsung 980 1TB NVMe', 'hike', 4500, 4800, 4300),
    _c('st_990pro_1tb', 'Samsung 990 Pro 1TB NVMe', 'normal', 6500, 6800, 6300),
    _c('st_990pro_2tb', 'Samsung 990 Pro 2TB NVMe', 'sale', 9500, 10000, 9200, 'PC Express'),
    _c('st_sn850x_1tb', 'WD Black SN850X 1TB NVMe', 'normal', 6200, 6500, 6000),
    _c('st_sn850x_2tb', 'WD Black SN850X 2TB NVMe', 'sale', 8500, 10000, 9200, 'PC Express'),
    _c('st_870evo_1tb', 'Samsung 870 EVO 1TB SATA', 'normal', 4500, 4800, 4300),
    _c('st_870evo_4tb', 'Samsung 870 EVO 4TB SATA', 'normal', 13500, 14000, 13000),
    _c('st_barracuda_8tb', 'Seagate Barracuda 8TB HDD', 'normal', 7000, 7500, 6800),
  ];

  static final _psus = [
    _c('psu_hv550', 'FSP HV Pro 550W 80+', 'normal', 2000, 2200, 1900),
    _c('psu_mwe550', 'Cooler Master MWE 550W 80+ Bronze', 'sale', 2600, 2800, 2500, 'EasyPC'),
    _c('psu_s12iii550', 'Seasonic S12III 550W 80+ Bronze', 'normal', 2900, 3100, 2800),
    _c('psu_gd550', 'FSP Hydro GD 550W 80+ Gold', 'normal', 3200, 3400, 3000),
    _c('psu_rm750e', 'Corsair RM750e 750W 80+ Gold', 'normal', 5500, 5800, 5300),
    _c('psu_rm750x', 'Corsair RM750x 750W 80+ Gold', 'hike', 6500, 6800, 6200),
    _c('psu_rm850x', 'Corsair RM850x 850W 80+ Gold', 'normal', 7500, 7800, 7200),
    _c('psu_rm1000x', 'Corsair RM1000x 1000W 80+ Gold', 'sale', 9500, 10000, 9200, 'PC Express'),
    _c('psu_tx850', 'Seasonic PRIME TX-850 80+ Titanium', 'normal', 9500, 10000, 9200),
    _c('psu_dark13', 'be quiet! Dark Power 13 850W', 'normal', 8500, 8800, 8200),
  ];

  static final _cases = [
    _c('case_flatline', 'Tecware Flatline (3 fans)', 'normal', 1800, 2000, 1700, 'EasyPC'),
    _c('case_forge_m', 'Tecware Forge M (4 fans)', 'normal', 2200, 2400, 2100),
    _c('case_dlm21', 'DarkFlash DLM21 Mesh', 'normal', 1600, 1800, 1500),
    _c('case_focus_g', 'Fractal Design Focus G', 'sale', 3200, 3500, 3000, 'DataBlitz'),
    _c('case_h510', 'NZXT H510 Flow', 'normal', 3800, 4000, 3600),
    _c('case_h5', 'NZXT H5 Flow', 'hike', 5500, 5800, 5200),
    _c('case_h7', 'NZXT H7 Flow', 'normal', 6500, 6800, 6200),
    _c('case_lancool205', 'Lian Li LANCOOL 205M', 'normal', 3500, 3800, 3300),
    _c('case_lancool216', 'Lian Li LANCOOL 216', 'hike', 4200, 4500, 4100, 'EasyPC'),
    _c('case_o11d', 'Lian Li O11 Dynamic EVO', 'normal', 8500, 8800, 8200),
  ];

  static final _coolers = [
    _c('cool_wraith', 'AMD Wraith Stealth (stock)', 'normal', 0, 0, 0),
    _c('cool_212', 'Cooler Master Hyper 212 Spectrum', 'normal', 1800, 2000, 1700),
    _c('cool_ak400', 'DeepCool AK400', 'sale', 1600, 1800, 1500, 'EasyPC'),
    _c('cool_d15', 'Noctua NH-D15', 'normal', 5500, 5800, 5200),
    _c('cool_kraken_x53', 'NZXT Kraken X53 240mm AIO', 'normal', 6500, 6800, 6200),
    _c('cool_kraken_x73', 'NZXT Kraken X73 360mm AIO', 'hike', 9500, 10000, 9200),
    _c('cool_arctic_360', 'Arctic Liquid Freezer III 360', 'sale', 5500, 5800, 5200, 'DataBlitz'),
    _c('cool_arctic_420', 'Arctic Liquid Freezer III 420', 'normal', 7500, 7800, 7200),
  ];

  static final _monitors = [
    _c('mon_aoc_24', 'AOC 24G2SP 24" 165Hz IPS', 'sale', 8200, 8500, 8000, 'DataBlitz'),
    _c('mon_aoc_27', 'AOC 27G2SP 27" 165Hz IPS', 'normal', 10500, 11000, 10000),
    _c('mon_view_24', 'ViewSonic VA2432-H 24" IPS', 'normal', 5500, 5800, 5300),
    _c('mon_dell_s27', 'Dell S2722QC 27" 4K IPS', 'sale', 15500, 16000, 15000, 'DataBlitz'),
    _c('mon_gig_g27', 'Gigabyte G27Q 27" 144Hz IPS', 'normal', 12500, 13000, 12000),
    _c('mon_lg_27', 'LG 27GP850-B 27" 165Hz Nano IPS', 'hike', 18500, 19000, 18000),
    _c('mon_sam_odyssey', 'Samsung Odyssey G5 27" 144Hz VA', 'normal', 14500, 15000, 14000),
    _c('mon_asus_vg27', 'ASUS VG27AQ1A 27" 170Hz IPS', 'sale', 16500, 17000, 16000, 'PC Express'),
    _c('mon_msi_24', 'MSI G2412 24" 170Hz IPS', 'normal', 7500, 7800, 7200),
    _c('mon_benq_27', 'BenQ PD2705Q 27" 2K IPS', 'normal', 18500, 19000, 18000),
  ];

  static final _peripherals = [
    _c('kb_redragon', 'Redragon K552 Kumara Mechanical', 'sale', 1400, 1600, 1300, 'EasyPC'),
    _c('kb_g413', 'Logitech G413 Mechanical', 'normal', 3500, 3800, 3300),
    _c('kb_g915', 'Logitech G915 TKL Wireless', 'hike', 9500, 10000, 9200),
    _c('ms_g304', 'Logitech G304 Lightspeed Wireless', 'normal', 1600, 1800, 1500),
    _c('ms_g502', 'Logitech G502 HERO', 'sale', 2800, 3000, 2700, 'DataBlitz'),
    _c('ms_razer_v2', 'Razer DeathAdder V2', 'normal', 2500, 2700, 2400),
    _c('hs_cloud2', 'HyperX Cloud Stinger 2', 'normal', 2400, 2600, 2300),
    _c('hs_alpha', 'HyperX Cloud Alpha', 'sale', 3800, 4000, 3600, 'EasyPC'),
    _c('hs_arctis7', 'SteelSeries Arctis 7+ Wireless', 'normal', 7500, 7800, 7200),
    _c('fan_p12', 'Arctic P12 PWM 5-pack', 'normal', 1200, 1400, 1100),
    _c('fan_nf_a12', 'Noctua NF-A12x25 PWM', 'hike', 1800, 2000, 1700),
    _c('fan_ll120', 'Corsair LL120 RGB 3-pack', 'sale', 3200, 3500, 3000, 'DataBlitz'),
  ];

  static Map<String, dynamic> _c(
    String id,
    String name,
    String status,
    double shopee,
    double lazada,
    double manila, [
    String store = '',
  ]) {
    final prices = <String, dynamic>{'shopee': shopee, 'lazada': lazada, 'manila': manila};
    if (store.isNotEmpty) prices['manilaStore'] = store;
    final cat = _categoryOf(id);
    return {'id': id, 'name': name, 'category': cat, 'status': status, 'prices': prices};
  }

  static String _categoryOf(String id) {
    if (id.startsWith('cpu')) return 'CPU';
    if (id.startsWith('gpu')) return 'GPU';
    if (id.startsWith('ram')) return 'RAM';
    if (id.startsWith('mb_')) return 'Motherboard';
    if (id.startsWith('st_')) return 'Storage';
    if (id.startsWith('psu')) return 'PSU';
    if (id.startsWith('case')) return 'Case';
    if (id.startsWith('cool')) return 'Cooler';
    if (id.startsWith('mon_')) return 'Monitor';
    if (id.startsWith('kb_') || id.startsWith('ms_') || id.startsWith('hs_') || id.startsWith('fan_')) return 'Peripheral';
    return 'Other';
  }

  static List<Map<String, dynamic>> fetchAll() => getComponents();

  static List<Map<String, dynamic>> filterByCategory(String category) =>
      getComponents().where((c) => c['category'] == category).toList();

  static List<Map<String, dynamic>> filterByStatus(String status) =>
      getComponents().where((c) => c['status'] == status).toList();

  // ─── Alerts ────────────────────────────────────────────────────
  static List<Map<String, dynamic>> getAlerts() => [
    _a('gpu_rx6600', 'Radeon RX 6600 8GB', 'Shopee PH', 13500, 11500, -14.8, 'sale', 3),
    _a('ram_ddr4_16', 'G.Skill Ripjaws V 16GB DDR4 3600', 'Shopee PH', 2800, 2200, -21.4, 'sale', 8),
    _a('cpu_i5_13600k', 'Intel Core i5-13600KF', 'DataBlitz', 11800, 12800, 8.5, 'hike', 14),
    _a('gpu_rtx4070tis', 'NVIDIA RTX 4070 Ti Super 16GB', 'EasyPC', 41000, 42500, 3.7, 'hike', 24),
    _a('st_sn850x_2tb', 'WD Black SN850X 2TB NVMe', 'Shopee PH', 10500, 8500, -19.0, 'sale', 36),
    _a('mon_aoc_24', 'AOC 24G2SP 24" 165Hz IPS', 'DataBlitz', 8500, 8000, -5.9, 'sale', 48),
    _a('case_lancool216', 'Lian Li LANCOOL 216', 'EasyPC', 3800, 4100, 7.9, 'hike', 72),
    _a('gpu_rx6600', 'Radeon RX 6600 8GB', 'Lazada PH', 14000, 13000, -7.1, 'sale', 96),
    _a('cpu_5600', 'AMD Ryzen 5 5600', 'PC Express', 6500, 6000, -7.7, 'sale', 120),
    _a('psu_rm1000x', 'Corsair RM1000x 1000W', 'Shopee PH', 10500, 9500, -9.5, 'sale', 168),
  ];

  static Map<String, dynamic> _a(
    String id, String name, String store, double oldP, double newP,
    double change, String type, int hoursAgo,
  ) {
    return {
      'id': 'alert_$id',
      'componentId': id,
      'componentName': name,
      'store': store,
      'oldPrice': oldP,
      'newPrice': newP,
      'changePercent': change,
      'type': type,
      'createdAt': TimestampMock(DateTime.now().subtract(Duration(hours: hoursAgo))),
    };
  }
}

class TimestampMock {
  final DateTime date;
  const TimestampMock(this.date);
  DateTime toDate() => date;
}
