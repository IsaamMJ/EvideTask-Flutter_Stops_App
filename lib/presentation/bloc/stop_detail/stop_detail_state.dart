import 'package:equatable/equatable.dart';
import '../../../domain/entities/stop.dart';

abstract class StopDetailState extends Equatable {
  const StopDetailState();

  @override
  List<Object> get props => [];
}

class StopDetailInitial extends StopDetailState {}

class StopDetailLoading extends StopDetailState {}

class StopDetailLoaded extends StopDetailState {
  final Stop stop;

  const StopDetailLoaded(this.stop);

  @override
  List<Object> get props => [stop];
}

class StopDetailError extends StopDetailState {
  final String message;

  const StopDetailError(this.message);

  @override
  List<Object> get props => [message];
}