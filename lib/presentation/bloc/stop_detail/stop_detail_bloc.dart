import 'package:flutter_bloc/flutter_bloc.dart';
import 'stop_detail_event.dart';
import 'stop_detail_state.dart';
import '../../../../domain/usecases/get_stop_detail.dart';
import '../../../../domain/usecases/toggle_favorite.dart';

class StopDetailBloc extends Bloc<StopDetailEvent, StopDetailState> {
  final GetStopDetail getStopDetail;
  final ToggleFavorite toggleFavorite;

  StopDetailBloc({
    required this.getStopDetail,
    required this.toggleFavorite,
  }) : super(StopDetailInitial()) {
    on<LoadStopDetail>(_onLoadStopDetail);
    on<ToggleFavoriteDetail>(_onToggleFavoriteDetail);
  }

  Future<void> _onLoadStopDetail(LoadStopDetail event, Emitter<StopDetailState> emit) async {
    emit(StopDetailLoading());
    try {
      final stop = await getStopDetail(event.stopId);
      if (stop != null) {
        emit(StopDetailLoaded(stop));
      } else {
        emit(const StopDetailError('Stop not found'));
      }
    } catch (e) {
      emit(StopDetailError('Failed to load stop details: $e'));
    }
  }

  Future<void> _onToggleFavoriteDetail(ToggleFavoriteDetail event, Emitter<StopDetailState> emit) async {
    if (state is StopDetailLoaded) {
      try {
        await toggleFavorite(event.stopId);
        // Reload to get updated favorite status
        add(LoadStopDetail(event.stopId));
      } catch (e) {
        emit(StopDetailError('Failed to toggle favorite: $e'));
      }
    }
  }
}