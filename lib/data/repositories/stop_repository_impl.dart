// lib/data/repositories/stop_repository_impl.dart
import '../../domain/entities/stop.dart';
import '../../domain/repositories/stop_repository.dart';
import '../datasources/stop_local_datasources.dart';
import '../models/stop_model.dart';

class StopRepositoryImpl implements StopRepository {
  final StopLocalDataSource localDataSource;

  StopRepositoryImpl(this.localDataSource);

  List<StopModel> _cache = [];

  @override
  Future<List<Stop>> getStops() async {
    _cache = await localDataSource.loadStops();
    return _cache;
  }

  @override
  Future<Stop?> getStopDetail(int id) async {
    if (_cache.isEmpty) {
      _cache = await localDataSource.loadStops();
    }
    try {
      return _cache.firstWhere((stop) => stop.id == id);
    } catch (e) {
      return null; // Stop not found
    }
  }

  @override
  Future<void> toggleFavorite(int id) async {
    await localDataSource.toggleFavorite(id);
    // Update cache
    _cache = await localDataSource.loadStops();
  }

  @override
  Future<List<Stop>> searchStops(String query) async {
    if (_cache.isEmpty) {
      _cache = await localDataSource.loadStops();
    }
    return _cache
        .where((stop) => stop.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
