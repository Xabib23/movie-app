import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies_app/domain/hive/hive_keys.dart';

import 'favourite_movie_model.dart';

abstract final class HiveBox {
  static final Box<FavouriteMovieModel> favouriteBox =
      Hive.box<FavouriteMovieModel>(HiveKeys.favouriteKey);
}
