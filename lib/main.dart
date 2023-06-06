import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/configs/app_settings.dart';
import 'package:first_app/configs/hive_config.dart';
import 'package:first_app/my_app.dart';
import 'package:first_app/repositories/account_repository.dart';
import 'package:first_app/repositories/favorites_repository.dart';
import 'package:first_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding();
  await HiveConfig.start();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthService()),
      ChangeNotifierProvider(create: (context) => AccountRepository()),
      ChangeNotifierProvider(create: (context) => FavoriteRepository()),
      ChangeNotifierProvider(create: (context) => AppSettings()),
    ],
    child: const MyApp(),
  ));
}
