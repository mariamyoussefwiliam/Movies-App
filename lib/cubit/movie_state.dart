part of 'movie_cubit.dart';

abstract class MoviesState {}

class MoviesInitial extends MoviesState {}


class PopularMoviesLoaded extends MoviesState {
  final List<MoviesResults> movies;

  PopularMoviesLoaded(this.movies);
}

class PopularMoviesLoading extends MoviesState {
  final List<MoviesResults> oldMovies;
  final bool isFirstFetch;

  PopularMoviesLoading(this.oldMovies, {this.isFirstFetch=false});
}
class PopularMoviesError extends MoviesState {

  final String error;
  PopularMoviesError(this.error);

}


class TopMoviesLoaded extends MoviesState {
  final List<MoviesResults> movies;

  TopMoviesLoaded(this.movies);
}

class TopMoviesLoading extends MoviesState {
  final List<MoviesResults> oldMovies;
  final bool isFirstFetch;

  TopMoviesLoading(this.oldMovies, {this.isFirstFetch=false});
}
class TopMoviesError extends MoviesState {

  final String error;
  TopMoviesError(this.error);

}




class NowPlayingMoviesLoaded extends MoviesState {
  final List<MoviesResults> movies;

  NowPlayingMoviesLoaded(this.movies);
}

class NowPlayingMoviesLoading extends MoviesState {
  final List<MoviesResults> oldMovies;
  final bool isFirstFetch;

  NowPlayingMoviesLoading(this.oldMovies, {this.isFirstFetch=false});
}
class NowPlayingMoviesError extends MoviesState {

  final String error;
  NowPlayingMoviesError(this.error);

}

class ChangeIndexState extends MoviesState
{

}