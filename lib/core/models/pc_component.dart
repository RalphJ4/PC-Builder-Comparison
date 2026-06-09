import 'price_snapshot.dart';

enum PriceStatus { sale, hike, normal }

class PcComponent {
  final String id;
  final String category;
  final String name;
  final String why;
  final PriceSnapshot prices;
  final PriceStatus status;
  final String statusNote;
  final double? originalPrice;
  final DateTime lastUpdated;

  PcComponent({
    required this.id,
    required this.category,
    required this.name,
    required this.why,
    required this.prices,
    required this.status,
    this.statusNote = '',
    this.originalPrice,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory PcComponent.fromJson(Map<String, dynamic> json) {
    return PcComponent(
      id: json['id'] as String,
      category: json['category'] as String,
      name: json['name'] as String,
      why: json['why'] as String? ?? '',
      prices: PriceSnapshot.fromJson(json['prices'] as Map<String, dynamic>),
      status: PriceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PriceStatus.normal,
      ),
      statusNote: json['statusNote'] as String? ?? '',
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'name': name,
    'why': why,
    'prices': prices.toJson(),
    'status': status.name,
    'statusNote': statusNote,
    'originalPrice': originalPrice,
  };
}
