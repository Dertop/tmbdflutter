import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/movies/abstract_movies_repository.dart';
import 'package:flutter_application_1/repositories/movies/movies_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'movies_list_app.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton<AbstractMoviesRepository>(
    MoviesRepository(),
  );
  GetIt.instance.registerLazySingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );
  await GetIt.instance.isReady<SharedPreferences>();

  runApp(const MyApp());
}
