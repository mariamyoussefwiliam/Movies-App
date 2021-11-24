part of 'movie_cubit.dart';

abstract class MoviesState {}

class MoviesInitial extends MoviesState {}
class MoviesLoaded extends MoviesState {
  final List<MoviesResults> movies;

  MoviesLoaded(this.movies);
}

class MoviesLoading extends MoviesState {
  final List<MoviesResults> oldMovies;
  final bool isFirstFetch;

  MoviesLoading(this.oldMovies, {this.isFirstFetch=false});
}
class MoviesError extends MoviesState {

  final String error;
  MoviesError(this.error);

}