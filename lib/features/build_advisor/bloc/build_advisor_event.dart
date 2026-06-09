import 'package:equatable/equatable.dart';
import '../../../core/models/pc_build.dart';

abstract class BuildAdvisorEvent extends Equatable {
  const BuildAdvisorEvent();

  @override
  List<Object?> get props => [];
}

class GenerateBuildEvent extends BuildAdvisorEvent {
  final double budget;
  final String useCase;
  final List<String> priorities;
  final String peripherals;
  final String stores;

  const GenerateBuildEvent({
    required this.budget,
    required this.useCase,
    this.priorities = const [],
    this.peripherals = 'PC only',
    this.stores = 'All sources',
  });

  @override
  List<Object?> get props => [budget, useCase, priorities, peripherals, stores];
}

class SaveBuildEvent extends BuildAdvisorEvent {
  final PcBuild build;

  const SaveBuildEvent(this.build);

  @override
  List<Object?> get props => [build];
}

class RegenerateBuildEvent extends BuildAdvisorEvent {}
