import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_application_1/repositories/movies/models/movie.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'abstract_movies_repository.dart';

class MoviesRepository implements AbstractMoviesRepository {
  
  final Dio dio = Dio();

  @override
  Future<List<Movie>?> getMovieList({
    required int pageKey
  }) async {
    try {
      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/now_playing',
        queryParameters: {
          "page": pageKey
        },
        options: Options(
          headers: {
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwODZjY2Q3MDA4MDZmNjlmZjc0M2JiMGFjN2I5NjRjNSIsInN1YiI6IjY2NGRhNTQ4NWM0N2IyYjQ4YTE4OGE5ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4S05_cuellrV2PRIirdCrBWJ-P2U9UfQwk6ak1a6How",
            "accept": "application/json"
          }
        )
      );
    
      final results = response.data['results'];

      final moviesList = (results as List?)
        ?.map((e) => Movie.fromJson(e))
        .toList();
      
      final result = (((moviesList?.length ?? 0) >= 10) == true) ? (moviesList ?? []).sublist(0, 10) : moviesList;

      return result;
    } catch (_) {
      throw "Load movies error";
    }
  }
  
  @override
  Future<MovieDetail> getMovieDetail({required String id}) async {
    try {
      final SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();

      if (sharedPreferences.containsKey(id)) {
        final String? cachedStringEncoded = sharedPreferences.getString(id);

        if (cachedStringEncoded == null) throw "Cached not found";

        final json = jsonDecode(cachedStringEncoded);
        final MovieDetail result = MovieDetail.fromJson(json);
        return result;
        
      } else {
        final response = await dio.get(
          'https://api.themoviedb.org/3/movie/$id',
          options: Options(
            headers: {
              "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwODZjY2Q3MDA4MDZmNjlmZjc0M2JiMGFjN2I5NjRjNSIsInN1YiI6IjY2NGRhNTQ4NWM0N2IyYjQ4YTE4OGE5ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4S05_cuellrV2PRIirdCrBWJ-P2U9UfQwk6ak1a6How",
              "accept": "application/json"
            }
          )
        );
        final MovieDetail result = MovieDetail.fromJson(response.data);
        await sharedPreferences.setString(id, jsonEncode(result));
        return result;
      }
    } catch (_) {
       throw "Load movies details error";
    }
  }
}
