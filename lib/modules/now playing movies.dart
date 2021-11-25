
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
        return _loadingIndicator();
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
                    return MovieItem(nowPlaylistMovies,size);
                  else {
                    Timer(Duration(seconds: 20), () {
                      scrollController
                          .jumpTo(scrollController.position.maxScrollExtent);
                    });

                    return _loadingIndicator();
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
                      image:"assets/no internet.gif",
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
                    image:"assets/no internet.png",
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

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget MovieItem(movie,size) {
    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
              children: [


                SizedBox(height: 10.0),
                GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: ((size.width / 2) / (size
                            .height / 2.3))
                    ),
                    itemCount: movie.length,
                    itemBuilder: (BuildContext context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Description(
                                    name: nowPlaylistMovies[index].title,
                                    bannerurl:
                                    'https://image.tmdb.org/t/p/w500' +
                                        nowPlaylistMovies[index].backdropPath,
                                    posterurl:
                                    'https://image.tmdb.org/t/p/w500' +
                                        nowPlaylistMovies[index].posterPath,
                                    description: nowPlaylistMovies[index].overview,
                                    vote: nowPlaylistMovies[index].voteAverage
                                        .toString(),
                                    launch_on: nowPlaylistMovies[index].releaseDate,
                                  )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                // height: (size.height/2),
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      20.0),
                                ),
                                child: (movie[index].posterPath == null) ?
                                Image.asset(
                                  'images/default movie poster.jpg',
                                  width: double.infinity,
                                  height: (size.height / 3.2),
                                  fit: BoxFit.fill,
                                )
                                    : Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie[index]
                                      .posterPath.toString()}'
                                  , width: double.infinity,
                                  height: (size.height / 3.2),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Center(
                                    child: Text(
                                      movie[index].title.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )

                            ],),
                        ),
                      );
                    }
                ),



              ]
          ),
        ),
      ),
    );
  }

}