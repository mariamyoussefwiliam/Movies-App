
import 'dart:async';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_task/cubit/movie_cubit.dart';
import 'package:movie_task/model/movies.dart';
import 'package:movie_task/network/component.dart';
import 'package:movie_task/network/constants.dart';
import 'package:movie_task/network/moviesapi.dart';

import 'details_screen.dart';

class NowPlayingMovies extends StatefulWidget {
  NowPlayingMovies(bool connected, {Key key}) : super(key: key);

  @override
  _TopMoviesState createState() => _TopMoviesState();
}

class _TopMoviesState extends State<NowPlayingMovies>  {
  @override
  void initState() {

    super.initState();
    BlocProvider.of<MoviesCubit>(context).loadNowPlayingMovies();
  }
  MoviesService moviesService = MoviesService();

  Future<Movies> movies;

  List<MoviesResults> nowPlaylistMovies;

  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<MoviesCubit>(context).loadNowPlayingMovies();

        }
      }
    });
  }

  List<MoviesResults> mov = [];

  bool isLoading = false;

  String message;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;


    return BlocBuilder<MoviesCubit, MoviesState>(builder: (context, state) {
      setupScrollController(context);

      if(state is ChangeIndexState&&MoviesCubit.get(context).index==2)
      {
        message=null;
        BlocProvider.of<MoviesCubit>(context).loadNowPlayingMovies();
        MoviesCubit.get(context).nowPlayingPage=1;
        if(nowPlaylistMovies!=null)
          nowPlaylistMovies.clear();

      }



      if (state is NowPlayingMoviesLoading && state.isFirstFetch  ) {
        return loadingIndicator();
      }

      if (state is NowPlayingMoviesLoading) {
        nowPlaylistMovies = state.oldMovies;
        isLoading = true;
      } else if (state is NowPlayingMoviesLoaded) {
        nowPlaylistMovies = state.movies;
      }
      if(state is NowPlayingMoviesError)
      {
        message=state.error;
      }

      return RefreshIndicator(
        onRefresh: ()async{
          MoviesCubit.get(context).nowPlayingPage=1;
          BlocProvider.of<MoviesCubit>(context).loadNowPlayingMovies();
          nowPlaylistMovies.clear();
        },
        child: ConditionalBuilder(
          condition: message==null,
          builder:(context)=> ConditionalBuilder(
            condition:connected ,
            builder:(context)=> ConditionalBuilder(
              condition:nowPlaylistMovies!=null ,
              builder: (context)=>ListView.separated(
                controller: scrollController,
                itemBuilder: (context, index) {
                  print(nowPlaylistMovies.length);

                  if (index < nowPlaylistMovies.length)
                    return MovieItem(nowPlaylistMovies,size,"now",context);
                  else {
                    Timer(Duration(seconds: 20), () {
                      scrollController
                          .jumpTo(scrollController.position.maxScrollExtent);
                    });

                    return loadingIndicator();
                  }

                },
                separatorBuilder: (context, index) {
                  return Container();
                },
                itemCount: 1 ,
              ),
              fallback: (context)=>Center(child: CircularProgressIndicator(),),
            ),
            fallback: (context)=>Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  emptyPage(
                      context: context,
                      image:"assets/no internet.jpg",
                      text: message??"Ouhh...Your're offline"),
                  MaterialButton(
                    color: Colors.white,
                    onPressed: (){

                      MoviesCubit.get(context).topPage=1;
                      BlocProvider.of<MoviesCubit>(context).loadNowPlayingMovies();
                      if(nowPlaylistMovies!=null)
                        nowPlaylistMovies.clear();
                    },
                    child: Text("retry",),
                  ),
                  SizedBox(height: 60,)
                ],
              ),
            ),
          ),
          fallback: (context)=>Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                emptyPage(
                    context: context,
                    image:"assets/no internet.jpg",
                    text: message??"Ouhh...Your're offline"),
                SizedBox(height: 50,),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:InkWell(
                    onTap: (){
                      message=null;
                      MoviesCubit.get(context).nowPlayingPage=1;
                      BlocProvider.of<MoviesCubit>(context).loadNowPlayingMovies();
                      if(nowPlaylistMovies!=null)
                        nowPlaylistMovies.clear();
                    },
                    child: Text("RETRY",
                      textAlign: TextAlign.center,

                      style: TextStyle(

                        color: Colors.redAccent,
                        fontSize: 20,


                      ),),
                  ),
                ),
                SizedBox(height: 60,)
              ],
            ),
          ),
        ),
      );
    });
  }


}