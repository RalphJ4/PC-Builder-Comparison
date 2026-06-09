class PriceSnapshot {
  final double? shopee;
  final double? lazada;
  final double? manila;
  final String manilaStoreName;
  final DateTime timestamp;

  PriceSnapshot({
    this.shopee,
    this.lazada,
    this.manila,
    this.manilaStoreName = '',
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory PriceSnapshot.fromJson(Map<String, dynamic> json) {
    return PriceSnapshot(
      shopee: (json['shopee'] as num?)?.toDouble(),
      lazada: (json['lazada'] as num?)?.toDouble(),
      manila: (json['manila'] as num?)?.toDouble(),
      manilaStoreName: json['manilaStore'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'shopee': shopee,
    'lazada': lazada,
    'manila': manila,
    'manilaStore': manilaStoreName,
  };

  double get bestPrice {
    final prices = [shopee, lazada, manila].whereType<double>();
    if (prices.isEmpty) return 0;
    return prices.reduce((a, b) => a < b ? a : b);
  }

  String get bestStore {
    if (bestPrice == shopee) return 'Shopee';
    if (bestPrice == lazada) return 'Lazada';
    if (bestPrice == manila) return manilaStoreName.isNotEmpty ? manilaStoreName : 'Manila Store';
    return '';
  }
}
