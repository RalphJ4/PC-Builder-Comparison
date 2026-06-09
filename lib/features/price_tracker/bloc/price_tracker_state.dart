import 'package:equatable/equatable.dart';

abstract class PriceTrackerState extends Equatable {
  const PriceTrackerState();

  @override
  List<Object?> get props => [];
}

class PriceTrackerInitial extends PriceTrackerState {}

class PriceTrackerLoading extends PriceTrackerState {}

class PriceTrackerLoaded extends PriceTrackerState {
  final List<Map<String, dynamic>> components;
  final List<String> watchlistIds;
  final String filter;

  const PriceTrackerLoaded({
    this.components = const [],
    this.watchlistIds = const [],
    this.filter = 'all',
  });

  PriceTrackerLoaded copyWith({
    List<Map<String, dynamic>>? components,
    List<String>? watchlistIds,
    String? filter,
  }) {
    return PriceTrackerLoaded(
      components: components ?? this.components,
      watchlistIds: watchlistIds ?? this.watchlistIds,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [components, watchlistIds, filter];
}

class PriceTrackerError extends PriceTrackerState {
  final String message;

  const PriceTrackerError(this.message);

  @override
  List<Object?> get props => [message];
}
