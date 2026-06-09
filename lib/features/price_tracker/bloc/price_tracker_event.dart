import 'package:equatable/equatable.dart';

abstract class PriceTrackerEvent extends Equatable {
  const PriceTrackerEvent();

  @override
  List<Object?> get props => [];
}

class LoadComponents extends PriceTrackerEvent {
  final String filter;

  const LoadComponents({this.filter = 'all'});

  @override
  List<Object?> get props => [filter];
}

class ToggleWatchlist extends PriceTrackerEvent {
  final String componentId;
  final Map<String, dynamic> component;

  const ToggleWatchlist(this.componentId, this.component);

  @override
  List<Object?> get props => [componentId, component];
}

class RefreshComponents extends PriceTrackerEvent {
  const RefreshComponents();
}
