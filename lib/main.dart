import 'package:flutter/material.dart';

import 'constants/app_router.dart';

void main() {
  runApp( MyApp(
      routeGenerator:RouteGenerator()
  ));
}

class MyApp extends StatelessWidget {
  final RouteGenerator routeGenerator;
  const MyApp({super.key,required this.routeGenerator});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: routeGenerator.getRoute,
      initialRoute: Routes.splashRoute,
    );
  }
}

