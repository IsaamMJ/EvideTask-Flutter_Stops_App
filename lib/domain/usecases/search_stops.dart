// lib/domain/usecases/search_stops.dart
import '../entities/stop.dart';
import '../repositories/stop_repository.dart';

class SearchStops {
  final StopRepository repository;

  SearchStops(this.repository);

  Future<List<Stop>> call(String query) async {
    return await repository.searchStops(query);
  }
}
