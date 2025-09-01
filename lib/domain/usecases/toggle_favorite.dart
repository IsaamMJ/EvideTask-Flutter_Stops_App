// lib/domain/usecases/toggle_favorite.dart
import '../repositories/stop_repository.dart';

class ToggleFavorite {
  final StopRepository repository;

  ToggleFavorite(this.repository);

  Future<void> call(int id) async {
    await repository.toggleFavorite(id);
  }
}
