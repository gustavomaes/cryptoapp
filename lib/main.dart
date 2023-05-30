import 'package:first_app/my_app.dart';
import 'package:first_app/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteRepository(),
      child: const MyApp(),
    )
  );
}
