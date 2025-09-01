// lib/domain/repositories/stop_repository.dart
import '../entities/stop.dart';

abstract class StopRepository {
  Future<List<Stop>> getStops();
  Future<Stop?> getStopDetail(int id);
  Future<void> toggleFavorite(int id);
  Future<List<Stop>> searchStops(String query);
}
