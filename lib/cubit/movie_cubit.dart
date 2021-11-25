import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_task/model/movies.dart';
import 'package:movie_task/network/moviesapi.dart';
import 'package:sqflite/sqflite.dart';

part 'movie_state.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit(this.repository) : super(MoviesInitial());

  static MoviesCubit get(context) => BlocProvider.of(context);
  int popularPage = 1;
  int topPage = 1;
  int nowPlayingPage = 1;
  final MoviesService repository;

  void loadPopularMovies() async {
    if (index == 0) {
      APIResult apiResult = await repository.popularMovies(popularPage);

      if (state is PopularMoviesLoading) return;
      var currentState;
      if(state is PopularMoviesLoading||state is PopularMoviesLoaded || state is TopMoviesLoading||state is TopMoviesLoaded|| state is NowPlayingMoviesLoading||state is NowPlayingMoviesLoaded)

        {
          if(state is !UpdateState)
            {
              currentState = state;
            }

        }



      var oldMovies = <MoviesResults>[];
      if (currentState is PopularMoviesLoaded && index == 0) {
        oldMovies = currentState.movies;
      }

      emit(PopularMoviesLoading(oldMovies, isFirstFetch: popularPage == 1));

      repository.popularMovies(popularPage).then((newMovies) {
        if (!apiResult.hasError) {
          popularPage++;

          final movies = (state as PopularMoviesLoading).oldMovies;
          movies.addAll(newMovies.data.results);

          emit(PopularMoviesLoaded(movies));
        }
        else {
          print(apiResult.failure.message);
          emit(PopularMoviesError(apiResult.failure.message));
        }
      }).catchError((error) {
        print(error.toString());
        emit(PopularMoviesError(error.toString()));
      });
    }
  }


  void loadNowPlayingMovies() async {
    if (index == 2) {
      APIResult apiResult = await repository.nowPlayingMovies(nowPlayingPage);

      if (state is NowPlayingMoviesLoading) return;

      final currentState = state;


      var oldMovies = <MoviesResults>[];
      if (currentState is NowPlayingMoviesLoaded && index == 2) {
        oldMovies = currentState.movies;
      }

      emit(NowPlayingMoviesLoading(
          oldMovies, isFirstFetch: nowPlayingPage == 1));

      repository.nowPlayingMovies(nowPlayingPage).then((newMovies) {
        if (!apiResult.hasError) {
          nowPlayingPage++;

          final movies = (state as NowPlayingMoviesLoading).oldMovies;
          movies.addAll(newMovies.data.results);

          emit(NowPlayingMoviesLoaded(movies));
        }
        else {
          print(apiResult.failure.message);
          emit(NowPlayingMoviesError(apiResult.failure.message));
        }
      }).catchError((error) {
        print(error.toString());
        emit(NowPlayingMoviesError(error.toString()));
      });
    }
  }

  void loadTopMovies() async {
    if (index == 1) {
      APIResult apiResult = await repository.topRatedMovies(topPage);

      if (state is TopMoviesLoading) return;

      final currentState = state;


      var oldMovies = <MoviesResults>[];
      if (currentState is TopMoviesLoaded) {
        oldMovies = currentState.movies;
      }


      emit(TopMoviesLoading(oldMovies, isFirstFetch: topPage == 1));


      repository.topRatedMovies(topPage).then((newMovies) {
        if (!apiResult.hasError) {
          topPage++;

          final movies = (state as TopMoviesLoading).oldMovies;
          movies.addAll(newMovies.data.results);

          emit(TopMoviesLoaded(movies));
        }
        else {
          print(apiResult.failure.message);
          emit(TopMoviesError(apiResult.failure.message));
        }
      }).catchError((error) {
        print(error.toString());
        emit(TopMoviesError(error.toString()));
      });
    }
  }


  int index = 0;

  changeIndex(changedIndex) {
    emit(ChangeIndexState());
    index = changedIndex;
    print(index);
  }


  Database database;

  void createDatabase() async
  {
    openDatabase(
        "movies.db",
        version: 1,
        onCreate: (database, version) {
          print("database created");
          database.execute(
              "CREATE TABLE popular (adult BOOL,backdropPath TEXT,id INTEGER ,originalLanguage TEXT,posterPath TEXT  ,releaseDate TEXT ,video BOOL ,voteAverage TEXT ,voteCount INTEGER)",
          ).then((value) {
            print("popular table created");
          }).catchError((error) {
            print("error ${error.toString()}");
          });
          database.execute(
              "CREATE TABLE top (adult BOOL,backdropPath TEXT,id INTEGER ,originalLanguage TEXT,posterPath TEXT  ,releaseDate TEXT ,video BOOL ,voteAverage TEXT ,voteCount INTEGER)"
          ).then((value) {
            print("top table created");
          }).catchError((error) {
            print("error ${error.toString()}");
          });
          database.execute(

              "CREATE TABLE now (adult BOOL,backdropPath TEXT,id INTEGER ,originalLanguage TEXT,posterPath TEXT  ,releaseDate TEXT  ,video BOOL ,voteAverage TEXT ,voteCount INTEGER)",
          ).then((value) {
            print("now table created");
          }).catchError((error) {
            print("error ${error.toString()}");
          });
        },
        onOpen: (database) {

          if(popular.isEmpty)
            {
              getDateFromDatabase(database,"popular");
            }
           if(top.isEmpty)
            {
              getDateFromDatabase(database,"top");
            }
          if(now.isEmpty){
            getDateFromDatabase(database,"now");

          }



          print("database opened");

        }
    ).then((value) {
      database = value;

      emit(CreateDatabaseState());
    });
  }

  List<Map> popular=[];
  List<Map> top=[];
  List<Map> now=[];

  void getDateFromDatabase(Database database,tableName) async
  {

    emit(LoadingState());
    await database.rawQuery("SELECT * FROM $tableName").then((value) {
     print(" the number of element in database ${value.length}");

      value.forEach((element) {
        if(tableName=="popular")
          {
            popular.add(element);
          }
        else if(tableName=="top")
          {
            top.add(element);
          }
        else if(tableName=="now")
        {
          now.add(element);
        }

      });
     // print(movies.toString());
      emit(GetDataFromDatabaseState());
      emit(UpdateState());
    }

    );}

  Future insertDatabase({
    @required String tableName,
   @required bool adult,
    @required String backdropPath,
    @required   int id,
    @required  String originalLanguage,


    @required  String posterPath,
    @required  String releaseDate,
    @required bool video,
    @required  String voteAverage,
    @required  int voteCount

  }) async
  {
    return await database.transaction((txn) {
      txn.rawInsert(

          "INSERT INTO $tableName ('adult','backdropPath','id','originalLanguage','posterPath','releaseDate','video','voteAverage','voteCount') "
              "VALUES ('$adult','$backdropPath','$id','$originalLanguage','$posterPath','$releaseDate','$video','$voteAverage','$voteCount')"
     ).then((value) {
        print("insert successfully");
        getDateFromDatabase(database,tableName);
           emit(InsertDataIntoDatabaseState());

      }
      ).catchError((error) {
        print("${error.toString()}");
      });

      return null;
    });




  }

   Future<void> cleanDatabase({ @required table}) async {
    try{
      database.delete(table);
      emit(DeleteState());

    } catch(error){
      print(error.toString());
    }
  }

}

