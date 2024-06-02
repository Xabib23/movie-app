import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:movies_app/domain/hive/hive_boxes.dart';
import 'package:movies_app/domain/hive/hive_keys.dart';
import 'package:movies_app/ui/app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'domain/hive/favourite_movie_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();

  await Hive.initFlutter();
  Hive.registerAdapter(FavouriteMovieModelAdapter());
  await Hive.openBox<FavouriteMovieModel>(HiveKeys.favouriteKey);
  runApp(const MyApp());
}
