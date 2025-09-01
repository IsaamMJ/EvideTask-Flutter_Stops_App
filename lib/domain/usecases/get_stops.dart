// lib/domain/usecases/get_stops.dart
import '../entities/stop.dart';
import '../repositories/stop_repository.dart';

class GetStops {
  final StopRepository repository;

  GetStops(this.repository);

  Future<List<Stop>> call() async {
    return await repository.getStops();
  }
}
