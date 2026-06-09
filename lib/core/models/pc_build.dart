import 'pc_component.dart';

class BuildConfig {
  final double budget;
  final String useCase;
  final List<String> priorities;
  final String peripherals;
  final String stores;

  const BuildConfig({
    required this.budget,
    required this.useCase,
    this.priorities = const [],
    this.peripherals = 'PC only',
    this.stores = 'All sources',
  });

  Map<String, dynamic> toJson() => {
    'budget': budget,
    'useCase': useCase,
    'priorities': priorities,
    'peripherals': peripherals,
    'stores': stores,
  };
}

class PcBuild {
  final String id;
  final String summary;
  final double totalMin;
  final double totalMax;
  final double estimatedSavings;
  final List<PcComponent> components;
  final DateTime createdAt;
  final BuildConfig config;

  PcBuild({
    required this.id,
    required this.summary,
    required this.totalMin,
    required this.totalMax,
    this.estimatedSavings = 0,
    this.components = const [],
    DateTime? createdAt,
    required this.config,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PcBuild.fromJson(Map<String, dynamic> json) {
    return PcBuild(
      id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      summary: json['summary'] as String? ?? '',
      totalMin: (json['totalMin'] as num?)?.toDouble() ?? 0,
      totalMax: (json['totalMax'] as num?)?.toDouble() ?? 0,
      estimatedSavings: (json['estimatedSavings'] as num?)?.toDouble() ?? 0,
      components: (json['components'] as List<dynamic>?)
              ?.map((e) => PcComponent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      config: BuildConfig(
        budget: (json['config']?['budget'] as num?)?.toDouble() ?? 0,
        useCase: json['config']?['useCase'] as String? ?? '',
        priorities: (json['config']?['priorities'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        peripherals: json['config']?['peripherals'] as String? ?? 'PC only',
        stores: json['config']?['stores'] as String? ?? 'All sources',
      ),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'summary': summary,
    'totalMin': totalMin,
    'totalMax': totalMax,
    'estimatedSavings': estimatedSavings,
    'components': components.map((e) => e.toJson()).toList(),
    'config': config.toJson(),
    'createdAt': createdAt.toIso8601String(),
  };
}
