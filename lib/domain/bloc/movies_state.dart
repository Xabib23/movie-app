part of 'movies_bloc.dart';

sealed class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

final class MoviesInitial extends MoviesState {
  const MoviesInitial();
}

final class MoviesLoaded extends MoviesState {
  final MoviesList allMovies;

  const MoviesLoaded({required this.allMovies});

  @override
  List<Object> get props => [allMovies];

  MoviesLoaded copyWith(
    MoviesList? allMovies,
  ) {
    return MoviesLoaded(
      allMovies: allMovies ?? this.allMovies,
    );
  }
}

final class MovieDetailLoaded extends MoviesState {
  final MovieDetailModel movie;

  const MovieDetailLoaded({required this.movie});

  @override
  List<Object> get props => [movie];
}

final class MovieTrailerLoaded extends MoviesState {
  final MovieTrailerModel trailer;

  const MovieTrailerLoaded({required this.trailer});
  @override
  List<Object> get props => [trailer];
}

final class MovieInFavouriteLoaded extends MoviesState{
  final bool isFavourite;
  const MovieInFavouriteLoaded({required this.isFavourite});

  @override
  List<Object> get props => [isFavourite];
}
