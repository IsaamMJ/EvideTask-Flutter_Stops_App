// lib/domain/usecases/get_stop_detail.dart
import '../entities/stop.dart';
import '../repositories/stop_repository.dart';

class GetStopDetail {
  final StopRepository repository;

  GetStopDetail(this.repository);

  Future<Stop?> call(int id) async {
    return await repository.getStopDetail(id);
  }
}
