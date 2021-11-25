
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

class TopMovies extends StatefulWidget {
  TopMovies(bool connected, {Key key}) : super(key: key);

  @override
  _TopMoviesState createState() => _TopMoviesState();
}

class _TopMoviesState extends State<TopMovies>  {
  @override
  void initState() {

    super.initState();
    BlocProvider.of<MoviesCubit>(context).loadTopMovies();
  }
  MoviesService moviesService = MoviesService();

  Future<Movies> movies;

  List<MoviesResults> toplistMovies;

  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<MoviesCubit>(context).loadTopMovies();

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

         if(state is ChangeIndexState&&MoviesCubit.get(context).index==1)
         {message=null;
           BlocProvider.of<MoviesCubit>(context).loadTopMovies();

         MoviesCubit.get(context).topPage=1;

       }



      if (state is TopMoviesLoading && state.isFirstFetch) {
        return loadingIndicator();
      }

      if (state is TopMoviesLoading) {
        toplistMovies = state.oldMovies;
        isLoading = true;
      } else if (state is TopMoviesLoaded) {
        toplistMovies = state.movies;
      }
      if(state is TopMoviesError)
      {
        message=state.error;
      }

      return RefreshIndicator(
        onRefresh: ()async{
          MoviesCubit.get(context).topPage=1;
          BlocProvider.of<MoviesCubit>(context).loadTopMovies();
          toplistMovies.clear();
        },
        child: ConditionalBuilder(
          condition: message==null,
          builder:(context)=> ConditionalBuilder(
            condition:connected ,
            builder:(context)=> ConditionalBuilder(
              condition:toplistMovies!=null ,
              builder: (context)=>ListView.separated(
                controller: scrollController,
                itemBuilder: (context, index) {
                  print(toplistMovies.length);

                  if (index < toplistMovies.length)
                    return MovieItem(toplistMovies,size,"top",context);
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
                  SizedBox(height: 50,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:InkWell(
                      onTap: (){
                        message=null;
                        MoviesCubit.get(context).topPage=1;
                        BlocProvider.of<MoviesCubit>(context).loadTopMovies();
                        if(toplistMovies!=null)
                          toplistMovies.clear();
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
                      MoviesCubit.get(context).topPage=1;
                      BlocProvider.of<MoviesCubit>(context).loadTopMovies();
                      if(toplistMovies!=null)
                        toplistMovies.clear();
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