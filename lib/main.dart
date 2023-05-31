import 'package:first_app/configs/app_settings.dart';
import 'package:first_app/my_app.dart';
import 'package:first_app/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => FavoriteRepository()),
      ChangeNotifierProvider(create: (context) => AppSettings()),
    ],
    child: const MyApp(),
  ));
}
