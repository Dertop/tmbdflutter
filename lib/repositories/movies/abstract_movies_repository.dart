import 'models/movie.dart';

abstract class AbstractMoviesRepository {

   Future<List<Movie>?> getMovieList({required int pageKey});
   Future<MovieDetail> getMovieDetail({required String id});
   
}