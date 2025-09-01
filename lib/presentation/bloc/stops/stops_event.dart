import 'package:equatable/equatable.dart';

abstract class StopsEvent extends Equatable {
  const StopsEvent();

  @override
  List<Object> get props => [];
}

class LoadStops extends StopsEvent {}

class SearchStops extends StopsEvent {
  final String query;

  const SearchStops(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleFavoriteStop extends StopsEvent {
  final int stopId;

  const ToggleFavoriteStop(this.stopId);

  @override
  List<Object> get props => [stopId];
}

class ClearSearch extends StopsEvent {}