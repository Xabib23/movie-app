part of 'movies_bloc.dart';

sealed class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

final class MoviesLoadEvent extends MoviesEvent {
  const MoviesLoadEvent();
}

final class GetMovieInCategoryEvent extends MoviesEvent {
  final String category;

  const GetMovieInCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

final class GetMovieDetailsEvent extends MoviesEvent {
  final num movieId;

  const GetMovieDetailsEvent({required this.movieId});

  @override
  List<Object> get props => [movieId];
}

final class GetMovieTrailerEvent extends MoviesEvent {
  final num id;

  const GetMovieTrailerEvent({required this.id});

  @override
  List<Object> get props => [id];
}

final class AddToFavouriteEvent extends MoviesEvent {
  final MovieDetailModel movie;
  final bool isFavourite;
  final int index;

  const AddToFavouriteEvent({
    required this.movie,
    required this.isFavourite,
    required this.index,
  });

  @override
  List<Object> get props => [movie];
}
