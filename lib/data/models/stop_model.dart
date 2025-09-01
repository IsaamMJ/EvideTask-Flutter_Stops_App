// lib/data/models/stop_model.dart
import '../../domain/entities/stop.dart';

class StopModel extends Stop {
  const StopModel({
    required int id,
    required String name,
    required String description,
    required double lat,
    required double lng,
    bool isFavorite = false,
  }) : super(
    id: id,
    name: name,
    description: description,
    lat: lat,
    lng: lng,
    isFavorite: isFavorite,
  );

  factory StopModel.fromJson(Map<String, dynamic> json, {bool isFavorite = false}) {
    return StopModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      isFavorite: isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'lat': lat,
      'lng': lng,
    };
  }
}
