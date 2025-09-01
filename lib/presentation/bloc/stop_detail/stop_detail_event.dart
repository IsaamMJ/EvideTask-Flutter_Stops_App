import 'package:equatable/equatable.dart';

abstract class StopDetailEvent extends Equatable {
  const StopDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadStopDetail extends StopDetailEvent {
  final int stopId;

  const LoadStopDetail(this.stopId);

  @override
  List<Object> get props => [stopId];
}

class ToggleFavoriteDetail extends StopDetailEvent {
  final int stopId;

  const ToggleFavoriteDetail(this.stopId);

  @override
  List<Object> get props => [stopId];
}