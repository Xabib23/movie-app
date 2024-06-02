import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movies_app/domain/bloc/movies_bloc.dart';
import 'package:movies_app/domain/bloc/upcoming_bloc.dart';
import 'package:movies_app/domain/router/app_router.dart';
import 'package:movies_app/ui/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        noAppBar: true,
        systemNavBarStyle: FlexSystemNavBarStyle.transparent,
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<UpcomingBloc>(
            create: (context) => UpcomingBloc()
              ..add(
                const UpcomingLoadEvent(),
              ),
          ),
          BlocProvider<MoviesBloc>(
            create: (context) => MoviesBloc()
              ..add(
                const MoviesLoadEvent(),
              ),
          ),
        ],
        child: const MyAppContent(),
      ),
    );
  }
}

class MyAppContent extends StatelessWidget {
  const MyAppContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: AppRouter.router,
      initialRoute: AppRouter.initialRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff242A32),
        fontFamily: 'Rubik'
      ),
    );
  }
}
