import 'package:equatable/equatable.dart';
import '../../../core/models/pc_build.dart';

abstract class BuildAdvisorState extends Equatable {
  const BuildAdvisorState();

  @override
  List<Object?> get props => [];
}

class BuildAdvisorInitial extends BuildAdvisorState {}

class BuildAdvisorLoading extends BuildAdvisorState {}

class BuildAdvisorSuccess extends BuildAdvisorState {
  final PcBuild build;

  const BuildAdvisorSuccess(this.build);

  @override
  List<Object?> get props => [build];
}

class BuildAdvisorError extends BuildAdvisorState {
  final String message;

  const BuildAdvisorError(this.message);

  @override
  List<Object?> get props => [message];
}
