import 'package:flutter_bloc/flutter_bloc.dart';
import 'stops_event.dart';
import 'stops_state.dart';
import '../../../../domain/usecases/get_stops.dart';
import '../../../../domain/usecases/search_stops.dart' as usecases;
import '../../../../domain/usecases/toggle_favorite.dart';

class StopsBloc extends Bloc<StopsEvent, StopsState> {
  final GetStops getStops;
  final usecases.SearchStops searchStops;
  final ToggleFavorite toggleFavorite;

  StopsBloc({
    required this.getStops,
    required this.searchStops,
    required this.toggleFavorite,
  }) : super(StopsInitial()) {
    on<LoadStops>(_onLoadStops);
    on<SearchStops>(_onSearchStops);
    on<ToggleFavoriteStop>(_onToggleFavoriteStop);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadStops(LoadStops event, Emitter<StopsState> emit) async {
    emit(StopsLoading());
    try {
      final stops = await getStops();
      emit(StopsLoaded(stops: stops));
    } catch (e) {
      emit(StopsError('Failed to load stops: $e'));
    }
  }

  Future<void> _onSearchStops(SearchStops event, Emitter<StopsState> emit) async {
    try {
      final stops = await searchStops(event.query);
      emit(StopsLoaded(
        stops: stops,
        searchQuery: event.query,
        isSearching: event.query.isNotEmpty,
      ));
    } catch (e) {
      emit(StopsError('Failed to search stops: $e'));
    }
  }

  Future<void> _onToggleFavoriteStop(ToggleFavoriteStop event, Emitter<StopsState> emit) async {
    if (state is StopsLoaded) {
      try {
        await toggleFavorite(event.stopId);
        // Reload to get updated favorite status
        if ((state as StopsLoaded).isSearching) {
          add(SearchStops((state as StopsLoaded).searchQuery));
        } else {
          add(LoadStops());
        }
      } catch (e) {
        emit(StopsError('Failed to toggle favorite: $e'));
      }
    }
  }

  Future<void> _onClearSearch(ClearSearch event, Emitter<StopsState> emit) async {
    add(LoadStops());
  }
}