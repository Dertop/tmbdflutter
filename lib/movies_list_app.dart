import 'package:flutter/material.dart';
import 'package:flutter_application_1/router/router.dart';
import 'theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Movie project',
      debugShowCheckedModeBanner: false,
      theme: dartTheme,
      routerConfig: AppRoutes.routes,
      
    );
  }
}