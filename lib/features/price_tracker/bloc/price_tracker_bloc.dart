import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'price_tracker_event.dart';
import 'price_tracker_state.dart';
import '../../../core/services/price_service.dart';

class PriceTrackerBloc extends Bloc<PriceTrackerEvent, PriceTrackerState> {
  final PriceService _priceService;

  PriceTrackerBloc(this._priceService) : super(PriceTrackerInitial()) {
    on<LoadComponents>(_onLoadComponents);
    on<ToggleWatchlist>(_onToggleWatchlist);
    on<RefreshComponents>(_onRefreshComponents);
  }

  Future<void> _onLoadComponents(
    LoadComponents event,
    Emitter<PriceTrackerState> emit,
  ) async {
    emit(PriceTrackerLoading());
    try {
      final watchlistIds = await _priceService.getWatchedIds();
      List<Map<String, dynamic>> components = [];

      if (event.filter == 'saved') {
        final prefs = await SharedPreferences.getInstance();
        final json = prefs.getStringList('watchlist') ?? [];
        components = json.map((e) {
          try {
            return jsonDecode(e) as Map<String, dynamic>;
          } catch (_) {
            return <String, dynamic>{};
          }
        }).where((m) => m.isNotEmpty).toList();
      } else {
        components = await _priceService.getAllComponents();
      }

      emit(PriceTrackerLoaded(
        components: components,
        watchlistIds: watchlistIds,
        filter: event.filter,
      ));
    } catch (e) {
      emit(PriceTrackerError(e.toString()));
    }
  }

  Future<void> _onToggleWatchlist(
    ToggleWatchlist event,
    Emitter<PriceTrackerState> emit,
  ) async {
    try {
      await _priceService.toggleWatchlistLocally(
        event.componentId,
        event.component,
      );

      if (state is PriceTrackerLoaded) {
        final current = state as PriceTrackerLoaded;
        final isCurrentlyWatched = current.watchlistIds.contains(event.componentId);
        final updatedIds = List<String>.from(current.watchlistIds);
        if (isCurrentlyWatched) {
          updatedIds.remove(event.componentId);
        } else {
          updatedIds.add(event.componentId);
        }
        emit(current.copyWith(watchlistIds: updatedIds));
      }
    } catch (e) {
      emit(PriceTrackerError(e.toString()));
    }
  }

  Future<void> _onRefreshComponents(
    RefreshComponents event,
    Emitter<PriceTrackerState> emit,
  ) async {
    add(const LoadComponents());
  }
}
