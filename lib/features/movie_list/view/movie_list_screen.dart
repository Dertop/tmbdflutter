import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/repositories/movies/abstract_movies_repository.dart';
import 'package:flutter_application_1/repositories/movies/models/movie.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});
  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {

  final PagingController<int, Movie?> pagingController = PagingController<int, Movie?>(firstPageKey: 1);

  @override
  void initState() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey: pageKey);
    });
    super.initState();
  }

  Future _fetchPage({required int pageKey}) async {
    try {
      log("page is $pageKey");
      final List<Movie>? items = await GetIt.I<AbstractMoviesRepository>().getMovieList(pageKey: pageKey);

      final isLastPage = (items?.length ?? 0) < 10;

      if (isLastPage) {
        pagingController.appendLastPage(items ?? []);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(items ?? [], nextPageKey);
      }
    } catch (e) {
      pagingController.error = e;
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "News",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body:  RefreshIndicator.adaptive(
        onRefresh: () => Future.sync(() => pagingController.refresh()),
        child: PagedListView<int, Movie?>(
          shrinkWrap: true,
          padding:  const EdgeInsets.all(2),
          physics: const AlwaysScrollableScrollPhysics(),
          pagingController: pagingController, 
          builderDelegate:PagedChildBuilderDelegate(
            animateTransitions: true,
            newPageProgressIndicatorBuilder: (context) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            },
            firstPageProgressIndicatorBuilder: (context) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              );
            },
            itemBuilder:(context, item, index) {
              return MovieListItemWidget(
                orientation: orientation,
                movie: item
              );
            },
          ), 
        ),
      ),
    );
  }
}

class MovieListItemWidget extends StatelessWidget {
  final Orientation orientation;
  final Movie? movie;
  const MovieListItemWidget({super.key, required this.movie,required this.orientation});

  @override
  Widget build(BuildContext context) {
    return (orientation == Orientation.portrait) 
      ? HorizontalMovieWidget(movie: movie)
      : VerticalMovieWidget(movie: movie);
  }
}

class VerticalMovieWidget extends StatelessWidget {
   final Movie? movie;
  const VerticalMovieWidget({super.key, required this.movie});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(top:20.0,left: 20,right: 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (movie?.id != null) {
              context.push("/movies/${movie?.id}/${movie?.title}");
            }
          },
          child: Ink(
            padding: const EdgeInsets.only(top:8.0,left: 8,right: 8,bottom: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(12)
            ),
            child: LayoutBuilder(
              builder: (context,constraints) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        if (movie?.posterPath != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "https://image.tmdb.org/t/p/w500${movie?.posterPath}",
                              fit: BoxFit.cover,
                              width: constraints.maxWidth * 0.4,
                              height: 200,
                            ),
                          ),
                        if (movie?.voteAverage != null)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text(
                                movie?.voteAverage?.toStringAsFixed(1) ?? "null",
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.black),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie?.title ?? "null",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                        ),
                        Text(
                          movie?.releaseDate ?? "null",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                        ),
                      ],
                    )
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}

class HorizontalMovieWidget extends StatelessWidget {
  final Movie? movie;
  const HorizontalMovieWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(top:20.0,left: 20,right: 20),
        child: InkWell(
          onTap: () {
            if (movie?.id != null) {
              context.push("/movies/${movie?.id}/${movie?.title}");
            }
          },
          child: Ink(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.white,
                width: 1
              ),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    if (movie?.posterPath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "https://image.tmdb.org/t/p/w500${movie?.posterPath}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    if (movie?.voteAverage != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            movie?.voteAverage?.toStringAsFixed(1) ?? "null",
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  movie?.title ?? "null",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                ),
                Text(
                  movie?.releaseDate ?? "null",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}