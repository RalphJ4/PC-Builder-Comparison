import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'build_advisor_event.dart';
import 'build_advisor_state.dart';
import '../../../core/models/pc_build.dart';
import '../../../core/services/ai_service.dart';

class BuildAdvisorBloc extends Bloc<BuildAdvisorEvent, BuildAdvisorState> {
  final AiService _aiService;

  BuildAdvisorBloc(this._aiService) : super(BuildAdvisorInitial()) {
    on<GenerateBuildEvent>(_onGenerateBuild);
    on<SaveBuildEvent>(_onSaveBuild);
    on<RegenerateBuildEvent>((event, emit) {
      emit(BuildAdvisorInitial());
    });
  }

  Future<void> _onGenerateBuild(
    GenerateBuildEvent event,
    Emitter<BuildAdvisorState> emit,
  ) async {
    emit(BuildAdvisorLoading());
    try {
      final config = BuildConfig(
        budget: event.budget,
        useCase: event.useCase,
        priorities: event.priorities,
        peripherals: event.peripherals,
        stores: event.stores,
      );
      final build = _aiService.generateBuild(config);
      emit(BuildAdvisorSuccess(build));
    } catch (e) {
      emit(BuildAdvisorError(e.toString()));
    }
  }

  Future<void> _onSaveBuild(
    SaveBuildEvent event,
    Emitter<BuildAdvisorState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final buildsJson = prefs.getStringList('saved_builds') ?? [];
      buildsJson.add(jsonEncode(event.build.toJson()));
      await prefs.setStringList('saved_builds', buildsJson);
    } catch (e) {
      emit(BuildAdvisorError('Failed to save build: $e'));
    }
  }
}
