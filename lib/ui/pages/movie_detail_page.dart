import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies_app/domain/models/movie_detail_model.dart';

import '../../domain/bloc/movies_bloc.dart';
import '../../domain/hive/favourite_movie_model.dart';

class MovieDetailPage extends StatelessWidget {
  final Box<FavouriteMovieModel> box;

  const MovieDetailPage({
    super.key,
    required this.box,
  });

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as int;
    final bloc = BlocProvider.of<MoviesBloc>(context);
    final bool isFavourite =
        box.values.map((e) => e.id == id).toList().contains(true)
            ? true
            : false;
    final index = box.values.map((e) => e.id == id).toList().indexOf(isFavourite);
    print(index);
    return BlocProvider(
      create: (context) => MoviesBloc()..add(GetMovieDetailsEvent(movieId: id)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Информация',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                if (state is! MovieDetailLoaded) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff0296E5),
                    ),
                  );
                }
                return IconButton(
                  onPressed: () {
                    bloc.add(AddToFavouriteEvent(
                        movie: state.movie,
                        isFavourite: isFavourite,
                        index: index));
                  },
                  color: Colors.white,
                  icon: isFavourite
                      ? const Icon(Icons.bookmark)
                      : const Icon(Icons.bookmark_outline_outlined),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocBuilder<MoviesBloc, MoviesState>(
          builder: (context, state) {
            if (state is! MovieDetailLoaded) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff0296E5),
                ),
              );
            }

            return SingleChildScrollView(
              child: MovieDetailPageContent(
                movie: state.movie,
              ),
            );
          },
        ),
      ),
    );
  }
}

class MovieDetailPageContent extends StatelessWidget {
  final MovieDetailModel movie;

  const MovieDetailPageContent({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final score = movie.voteAverage.toString()[0] +
        movie.voteAverage.toString()[1] +
        movie.voteAverage.toString()[2];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 400,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: SizedBox(
                  height: 320,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 16,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  child: SizedBox(
                    width: 140,
                    height: 180,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/original/${movie.posterPath}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 90,
                right: 20,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10,
                      sigmaY: 10,
                    ),
                    child: Container(
                      width: 60,
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(37, 40, 54, .3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Icon(
                            Icons.star_border_rounded,
                            color: Color(0xffFF8700),
                          ),
                          Text(
                            score,
                            style: const TextStyle(
                              color: Color(0xffFF8700),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 168,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 168,
                  child: Text(
                    movie.title ?? '',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        MovieDetailPageContentInfo(movie: movie),
        Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Text(
            movie.overview != null && movie.overview?.length != 0
                ? movie.overview ?? 'Error'
                : 'Нет описания',
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class MovieDetailPageContentInfo extends StatelessWidget {
  final MovieDetailModel movie;

  const MovieDetailPageContentInfo({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final String releaseDate =
        movie.releaseDate?.split('-').reversed.join('.') ?? '';
    final int duration = movie.runtime ?? 0;
    final genre = movie.genres?.first.name?.toUpperCase() ?? '';

    return BlocProvider(
      create: (context) =>
          MoviesBloc()..add(GetMovieTrailerEvent(id: movie.id ?? 0)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                if (state is! MovieTrailerLoaded) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff0296E5),
                    ),
                  );
                }
                return InkWell(
                  onTap: state.trailer.results!.isEmpty
                      ? null
                      : () {
                          final trailer =
                              state.trailer.results?.first.key ?? '';
                          Navigator.of(context).pushNamed(
                              '/movie_detail_page/trailer',
                              arguments: trailer);
                          // onChangeWatching();
                        },
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow_outlined,
                        size: 30,
                        color: state.trailer.results!.isEmpty
                            ? Colors.grey
                            : const Color(0xff0296E5),
                      ),
                      Text(
                        'Воспроизвести трейлер',
                        style: TextStyle(
                          color: state.trailer.results!.isEmpty
                              ? Colors.grey
                              : Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // if (isWatchingTrailer) ...[
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MovieDetailPageContentInfoItem(
                  data: releaseDate,
                ),
                const VerticalDivider(
                  color: Color(0xff92929D),
                ),
                MovieDetailPageContentInfoItem(
                  data: '$duration минут',
                  icon: Icons.watch_later_outlined,
                ),
                const VerticalDivider(
                  color: Color(0xff92929D),
                ),
                MovieDetailPageContentInfoItem(
                  data: genre,
                  icon: Icons.confirmation_num_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MovieDetailPageContentInfoItem extends StatelessWidget {
  final String data;
  final IconData icon;

  const MovieDetailPageContentInfoItem({
    super.key,
    this.data = 'Error',
    this.icon = Icons.calendar_today_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: const Color(0xff92929D),
        ),
        const SizedBox(width: 8),
        Text(
          data,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff92929D),
          ),
        ),
      ],
    );
  }
}
