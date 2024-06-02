import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movies_app/domain/hive/favourite_movie_model.dart';
import 'package:movies_app/domain/models/movie_trailer_model.dart';
import 'package:movies_app/domain/models/movies_model.dart';
import 'package:movies_app/domain/services/api_service.dart';
import 'package:movies_app/domain/hive/hive_boxes.dart';

import '../models/movie_detail_model.dart';

part 'movies_event.dart';

part 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  MoviesBloc() : super(const MoviesInitial()) {
    on<MoviesLoadEvent>(_load);
    on<GetMovieInCategoryEvent>(_getMovieInCategory);
    on<GetMovieDetailsEvent>(_getMovieDetails);
    on<GetMovieTrailerEvent>(_getMovieTrailer);
    on<AddToFavouriteEvent>(_addFav);
  }

  Future _load(
    MoviesLoadEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      final response = await ApiService.getMovies(
          'https://api.themoviedb.org/3/movie/now_playing?language=ru-RU&page=1');

      final Map<String, dynamic> jsonData =
          await json.decode(utf8.decode(response!.bodyBytes));

      final data = MoviesList.fromJson(jsonData['results']);

      emit(MoviesLoaded(allMovies: data));
    } catch (e) {
      e;
    }
  }

  Future<void> _getMovieInCategory(
    GetMovieInCategoryEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      final response = await ApiService.getMovies(
        'https://api.themoviedb.org/3/movie/${event.category}?language=ru-RU&page=1',
      );

      final jsonData = await json.decode(utf8.decode(response!.bodyBytes));
      final data = MoviesList.fromJson(jsonData['results']);

      emit(MoviesLoaded(allMovies: data));
    } catch (e) {
      e;
    }
  }

  Future<void> _getMovieDetails(
    GetMovieDetailsEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      final response = await ApiService.getMovieDetails(event.movieId);

      final jsonData = json.decode(utf8.decode(response!.bodyBytes));

      final data = MovieDetailModel.fromJson(jsonData);

      emit(MovieDetailLoaded(movie: data));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getMovieTrailer(
    GetMovieTrailerEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      final response = await ApiService.getMovieTrailer(event.id);
      final jsonData = json.decode(utf8.decode(response!.bodyBytes));
      final data = MovieTrailerModel.fromJson(jsonData);

      emit(MovieTrailerLoaded(trailer: data));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _addFav(
    AddToFavouriteEvent event,
    Emitter<MoviesState> emit,
  ) async {
    final movie = event.movie;
    if(event.isFavourite){
      print('remove');
      HiveBox.favouriteBox.deleteAt(event.index);
      emit(const MovieInFavouriteLoaded(isFavourite: false));
    }else{
      await HiveBox.favouriteBox.add(FavouriteMovieModel(
          id: movie.id,
          genra: movie.genres?.first.name,
          releaseDate: movie.releaseDate,
          runtime: movie.runtime,
          title: movie.title,
          posterPath: movie.posterPath,
          score: movie.voteAverage
      ));
      print('add');
      emit(const MovieInFavouriteLoaded(isFavourite: true));
    }


  }


}
