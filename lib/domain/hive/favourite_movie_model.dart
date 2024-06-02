import 'package:hive_flutter/hive_flutter.dart';

import '../models/movie_detail_model.dart';

part 'favourite_movie_model.g.dart';

@HiveType(typeId: 0)
final class FavouriteMovieModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final String? genra;
  @HiveField(3)
  final String? releaseDate;
  @HiveField(4)
  final int? runtime;
  @HiveField(5)
  final String? posterPath;
  @HiveField(6)
  final double? score;

  const FavouriteMovieModel( {
    required this.id,
    required this.title,
    required this.genra,
    required this.releaseDate,
    required this.runtime,
    required this.posterPath,
    required this.score,
  });
}
