// lib/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/stop_local_datasources.dart';
import '../../data/repositories/stop_repository_impl.dart';
import '../../domain/repositories/stop_repository.dart';
import '../../domain/usecases/get_stop_detail.dart';
import '../../domain/usecases/get_stops.dart';
import '../../domain/usecases/search_stops.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../presentation/bloc/stop_detail/stop_detail_bloc.dart';
import '../../presentation/bloc/stops/stops_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Data sources
  sl.registerLazySingleton<StopLocalDataSource>(
        () => StopLocalDataSourceImpl(),
  );

  // Repository
  sl.registerLazySingleton<StopRepository>(
        () => StopRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetStops(sl()));
  sl.registerLazySingleton(() => GetStopDetail(sl()));
  sl.registerLazySingleton(() => SearchStops(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));

  // BLoC
  sl.registerFactory(() => StopsBloc(
    getStops: sl(),
    searchStops: sl(),
    toggleFavorite: sl(),
  ));

  sl.registerFactory(() => StopDetailBloc(
    getStopDetail: sl(),
    toggleFavorite: sl(),
  ));
}