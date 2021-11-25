import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_task/model/movies.dart';
import 'package:movie_task/network/moviesapi.dart';

part 'movie_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit(this.repository) : super(MoviesInitial());
  static MoviesCubit get(context) => BlocProvider.of(context);
  int popularPage = 1;
  int topPage = 1;
  int nowPlayingPage = 1;
  final MoviesService repository;

  void loadPopularMovies() async {
    if(index==0)
      {
        APIResult apiResult=await repository.popularMovies(popularPage);

        if (state is PopularMoviesLoading) return;

        final currentState = state;


        var oldMovies = <MoviesResults>[];
        if (currentState is PopularMoviesLoaded&&index==0) {
          oldMovies = currentState.movies;
        }

        emit(PopularMoviesLoading(oldMovies, isFirstFetch: popularPage == 1));

        repository.popularMovies(popularPage).then((newMovies) {
          if(!apiResult.hasError)
          {
            popularPage++;

            final movies = (state as PopularMoviesLoading).oldMovies;
            movies.addAll(newMovies.data.results);

            emit(PopularMoviesLoaded(movies));
          }
          else
          {
            print(apiResult.failure.message);
            emit(PopularMoviesError(apiResult.failure.message));
          }

        }).catchError((error){
          print(error.toString());
          emit(PopularMoviesError(error.toString()));
        });
      }

  }



  void loadNowPlayingMovies() async {
    if(index==2)
      {
        APIResult apiResult=await repository.nowPlayingMovies(nowPlayingPage);

        if (state is NowPlayingMoviesLoading) return;

        final currentState = state;


        var oldMovies = <MoviesResults>[];
        if (currentState is NowPlayingMoviesLoaded&&index==2) {
          oldMovies = currentState.movies;
        }

        emit(NowPlayingMoviesLoading(oldMovies, isFirstFetch: nowPlayingPage == 1));

        repository.nowPlayingMovies(nowPlayingPage).then((newMovies) {
          if(!apiResult.hasError)
          {
            nowPlayingPage++;

            final movies = (state as NowPlayingMoviesLoading).oldMovies;
            movies.addAll(newMovies.data.results);

            emit(NowPlayingMoviesLoaded(movies));
          }
          else
          {
            print(apiResult.failure.message);
            emit(NowPlayingMoviesError(apiResult.failure.message));
          }

        }).catchError((error){
          print(error.toString());
          emit(NowPlayingMoviesError(error.toString()));
        });
      }

  }

  void loadTopMovies() async {
    if(index==1)
      {
        APIResult apiResult=await repository.topRatedMovies(topPage);

        if (state is TopMoviesLoading) return;

        final currentState = state;


        var oldMovies = <MoviesResults>[];
        if (currentState is TopMoviesLoaded) {
          oldMovies = currentState.movies;
        }


        emit(TopMoviesLoading(oldMovies, isFirstFetch: topPage == 1));



        repository.topRatedMovies(topPage).then((newMovies) {
          if(!apiResult.hasError)
          {
            topPage++;

            final movies = (state as TopMoviesLoading).oldMovies;
            movies.addAll(newMovies.data.results);

            emit(TopMoviesLoaded(movies));
          }
          else
          {
            print(apiResult.failure.message);
            emit(TopMoviesError(apiResult.failure.message));
          }


        }).catchError((error){
          print(error.toString());
          emit(TopMoviesError(error.toString()));
        });
      }

  }






  int index=0;
  changeIndex(changedIndex)
  { emit(ChangeIndexState());
    index=changedIndex;
    print(index);
  }
}
