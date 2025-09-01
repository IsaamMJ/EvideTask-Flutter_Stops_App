// lib/data/datasources/stop_local_datasource.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/stop_model.dart';

abstract class StopLocalDataSource {
  Future<List<StopModel>> loadStops();
  Future<void> toggleFavorite(int id);
  Future<Set<int>> getFavoriteIds();
}

class StopLocalDataSourceImpl implements StopLocalDataSource {
  static const String favoritesKey = 'favorite_stops';

  // In StopLocalDataSourceImpl
  @override
  Future<List<StopModel>> loadStops() async {
    try {
      final jsonString = await rootBundle.loadString('assets/mock/stops.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final favoriteIds = await getFavoriteIds();

      return jsonList
          .map((e) => StopModel.fromJson(e, isFavorite: favoriteIds.contains(e['id'])))
          .toList();
    } catch (e) {
      throw Exception('Failed to load stops: $e');
    }
  }

  @override
  Future<void> toggleFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = prefs.getStringList(favoritesKey) ?? [];

    if (currentFavorites.contains(id.toString())) {
      currentFavorites.remove(id.toString());
    } else {
      currentFavorites.add(id.toString());
    }

    await prefs.setStringList(favoritesKey, currentFavorites);
  }

  @override
  Future<Set<int>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final currentFavorites = prefs.getStringList(favoritesKey) ?? [];
    return currentFavorites.map((e) => int.parse(e)).toSet();
  }
}
