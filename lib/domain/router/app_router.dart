import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies_app/domain/hive/hive_boxes.dart';
import 'package:movies_app/ui/pages/movie_detail_page.dart';
import 'package:movies_app/ui/pages/movie_trailer_page.dart';

import '../../ui/pages/home_page.dart';

abstract class AppRouter {
  static const initialRoute = '/';

  static final Map<String, Widget Function(BuildContext)> router = {
    '/': (p0) => FlutterSplashScreen.scale(
          backgroundColor: const Color(0xff242A32),
          childWidget: Image.asset('assets/images/splash.png'),
          nextScreen: const HomePage(),
        ),
    '/movie_detail_page': (context) => ValueListenableBuilder(
      valueListenable: HiveBox.favouriteBox.listenable(),
          builder: (context, box, child) => MovieDetailPage(box:box),

        ),
    '/movie_detail_page/trailer': (context) => const MovieTrailerPage(),
  };
}
