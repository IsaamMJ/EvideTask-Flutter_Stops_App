import 'package:equatable/equatable.dart';
import '../../../domain/entities/stop.dart';

abstract class StopsState extends Equatable {
  const StopsState();

  @override
  List<Object> get props => [];
}

class StopsInitial extends StopsState {}

class StopsLoading extends StopsState {}

class StopsLoaded extends StopsState {
  final List<Stop> stops;
  final String searchQuery;
  final bool isSearching;

  const StopsLoaded({
    required this.stops,
    this.searchQuery = '',
    this.isSearching = false,
  });

  StopsLoaded copyWith({
    List<Stop>? stops,
    String? searchQuery,
    bool? isSearching,
  }) {
    return StopsLoaded(
      stops: stops ?? this.stops,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object> get props => [stops, searchQuery, isSearching];
}

class StopsError extends StopsState {
  final String message;

  const StopsError(this.message);

  @override
  List<Object> get props => [message];
}