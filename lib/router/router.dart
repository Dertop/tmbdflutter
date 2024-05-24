import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/movie/view/movie_screen.dart';
import 'package:flutter_application_1/features/movie_list/view/movie_list_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get getRootNavigatorKey => _rootNavigatorKey;

  static final routes = GoRouter(
    initialLocation: "/movies",

    routes: [
      GoRoute(
        path: '/movies',
        builder: (_, __) => const MovieListScreen(),
        routes: [
          GoRoute(
            path: ':id/:title',
            builder: (_, state) {
              final id = state.pathParameters['id'] ?? '';
              final title = state.pathParameters['title'];
              return MovieScreen(movieId: id, title: title);
            },
          ),
        ]
      ),
    ],
  );
}
