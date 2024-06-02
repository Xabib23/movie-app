import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lottie/lottie.dart';
import 'package:movies_app/domain/hive/hive_boxes.dart';
import 'package:movies_app/domain/router/app_router.dart';

import '../../domain/hive/favourite_movie_model.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveBox.favouriteBox.listenable(),
      builder: (context, box, child) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(
                top: 32,
                left: 16,
                bottom: 16,
                right: 16,
              ),
              child: const Center(
                child: Text(
                  'Избранное',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            Expanded(
              child: box.isNotEmpty? ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // shrinkWrap: true,
                itemBuilder: (context, index) {
                  final movie = box.values.toList()[index];
                  return MovieCard(movie: movie);
                },
                itemCount: box.length,
              ): Lottie.asset('assets/lottie/favourite.json'),
            ),
          ],
        );
      },
    );
  }
}

class MovieCard extends StatelessWidget {
  final FavouriteMovieModel movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/movie_detail_page', arguments: movie.id);
      },
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 150,
          child: Row(
            children: <Widget>[
              SizedBox(
                  width: 95,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/original/${movie.posterPath}',
                      fit: BoxFit.cover,
                    ),
                  )),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 168,
                    child: Text(
                      movie.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  MovieCardOptions(movie: movie),
                ],
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}

class MovieCardOptions extends StatelessWidget {
  final FavouriteMovieModel movie;

  const MovieCardOptions({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String releaseDate =
        movie.releaseDate?.split('-').reversed.join('.') ?? '';
    final int duration = movie.runtime ?? 0;
    final score = movie.score.toString()[0] +
        movie.score.toString()[1] +
        movie.score.toString()[2];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MovieCardOptionsItem(
          rating: true,
          data: score,
        ),
        MovieCardOptionsItem(
          icon: Icons.airplane_ticket,
          data: movie.genra ?? '',
        ),
        MovieCardOptionsItem(
          icon: Icons.calendar_today_outlined,
          data: releaseDate,
        ),
        MovieCardOptionsItem(
          icon: Icons.watch_later_outlined,
          data: '$duration минут',
        ),
      ],
    );
  }
}

class MovieCardOptionsItem extends StatelessWidget {
  final bool rating;
  final IconData icon;
  final String data;

  const MovieCardOptionsItem({
    super.key,
    this.rating = false,
    this.icon = Icons.star_border_rounded,
    this.data = 'Error',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          color: rating ? const Color(0xffFF8700) : Colors.white,
          size: 18,
        ),
        const SizedBox(width: 4),
        Text(
          data,
          style: TextStyle(
            color: rating ? const Color(0xffFF8700) : Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
