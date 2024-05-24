import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/movies/abstract_movies_repository.dart';
import 'package:flutter_application_1/repositories/movies/models/movie.dart';
import 'package:flutter_application_1/theme/theme.dart';
import 'package:get_it/get_it.dart';

class MovieScreen extends StatefulWidget {
  final String movieId;
  final String? title;
  const MovieScreen({super.key, required this.movieId, required this.title});
  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {

  late Future<MovieDetail> future = GetIt.I<AbstractMoviesRepository>().getMovieDetail(id: widget.movieId);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, or) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title ?? "Film"
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => Future.sync(() => setState(() {
              future = GetIt.I<AbstractMoviesRepository>().getMovieDetail(id: widget.movieId);
            })),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<MovieDetail>(
                future: future, 
                builder:(context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                      final MovieDetail? movie = snapshot.data;
                      if (or == Orientation.portrait) {
                        return VerticalMovieDetailWidget(movie: movie);                         
                      } else {
                        return HorizontalMovieDetailWidget(movie: movie);
                      }
                  }
                },
              ),
            ),
          ),
        );
      }
    );
  }
}

class HorizontalMovieDetailWidget extends StatelessWidget {
  final MovieDetail? movie;
  const HorizontalMovieDetailWidget({super.key,required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          "https://image.tmdb.org/t/p/w500${movie?.posterPath}",
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 20,),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie?.originalTitle ?? '',
                style: dartTheme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                movie?.releaseDate ?? '',
                style: dartTheme.textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Rating: ${movie?.voteAverage}',
                style: dartTheme.textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Overview: ${movie?.overview}',
                style: dartTheme.textTheme.labelSmall,
              ),
            ],
          ),
        )

      ],
    );
  }
}

class VerticalMovieDetailWidget extends StatelessWidget {
  final MovieDetail? movie;
  const VerticalMovieDetailWidget({super.key,required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.network(
            "https://image.tmdb.org/t/p/w500${movie?.posterPath}",
          ),
        ),
        const SizedBox(height: 16),
        Text(
          movie?.originalTitle ?? '',
          style: dartTheme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          movie?.releaseDate ?? '',
          style: dartTheme.textTheme.labelSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Rating: ${movie?.voteAverage}',
          style: dartTheme.textTheme.labelSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Overview: ${movie?.overview}',
          style: dartTheme.textTheme.labelSmall,
        ),
      ],
    );
  }
}