
import 'dart:async';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_task/cubit/movie_cubit.dart';
import 'package:movie_task/model/movies.dart';
import 'package:movie_task/network/moviesapi.dart';

import 'details_screen.dart';

class PopularMovies extends StatefulWidget {
  PopularMovies({Key key,}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PopularMovies> {

  MoviesService moviesService = MoviesService();
  Future<Movies> movies;
  List<MoviesResults> listMovies;

  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<MoviesCubit>(context).loadMovies();

        }
      }
    });
  }


  List<MoviesResults> mov = [];

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    setupScrollController(context);
    BlocProvider.of<MoviesCubit>(context).loadMovies();

    return BlocBuilder<MoviesCubit, MoviesState>(builder: (context, state) {
      if (state is MoviesLoading && state.isFirstFetch) {
        return _loadingIndicator();
      }

      if (state is MoviesLoading) {
        listMovies = state.oldMovies;
        isLoading = true;
      } else if (state is MoviesLoaded) {
        listMovies = state.movies;
      }

      return ConditionalBuilder(
        condition:listMovies!=null ,
        builder: (context)=>ListView.separated(
          controller: scrollController,
          itemBuilder: (context, index) {

            if (index < listMovies.length)
              return MovieItem(listMovies,size);
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
          itemCount: listMovies.length + (isLoading ? 1 : 0),
        ),
        fallback: (context)=>Center(child: CircularProgressIndicator(),),
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
                                          name: listMovies[index].title,
                                          bannerurl:
                                          'https://image.tmdb.org/t/p/w500' +
                                              listMovies[index].backdropPath,
                                          posterurl:
                                          'https://image.tmdb.org/t/p/w500' +
                                              listMovies[index].posterPath,
                                          description: listMovies[index].overview,
                                          vote: listMovies[index].voteAverage
                                              .toString(),
                                          launch_on: listMovies[index].releaseDate,
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
