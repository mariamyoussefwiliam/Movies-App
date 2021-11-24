import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_task/model/movies.dart';
import 'package:movie_task/network/moviesapi.dart';

part 'movie_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit(this.repository) : super(MoviesInitial());
  static MoviesCubit get(context) => BlocProvider.of(context);
  int page = 1;
  final MoviesService repository;

  void loadMovies() {


    if (state is MoviesLoading) return;

    final currentState = state;


    var oldMovies = <MoviesResults>[];
    if (currentState is MoviesLoaded) {
      oldMovies = currentState.movies;
    }

    emit(MoviesLoading(oldMovies, isFirstFetch: page == 1));

    repository.popularMovies(page).then((newMovies) {
      page++;

      final movies = (state as MoviesLoading).oldMovies;
      movies.addAll(newMovies.results);

      emit(MoviesLoaded(movies));
    }).catchError((error){
      emit(MoviesError(error.toString()));
    });
  }

}
