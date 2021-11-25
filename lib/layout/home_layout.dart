

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:movie_task/cubit/movie_cubit.dart';
import 'package:movie_task/modules/now%20playing%20movies.dart';
import 'package:movie_task/modules/popular%20movies.dart';
import 'package:movie_task/modules/top%20movies.dart';
import 'package:movie_task/network/constants.dart';

import 'package:movie_task/network/moviesapi.dart';

class HomeLayout extends StatelessWidget {
  final MoviesService repository;

  HomeLayout({Key key, this.repository}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          key: _scaffoldKey,
        backgroundColor: Colors.black26,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Movies App"),
         centerTitle: true,
         bottom: TabBar(
           controller: tabController,
           indicatorColor: Colors.redAccent,
           onTap: (value) {
             MoviesCubit.get(context).changeIndex(value);
           },

           tabs: [
             Tab(text: "Popular Movies",),
             Tab(text: "Top Movies",),
             Tab(text: "Now Playing ",),
           ],
         ),
        ),
        body:  Builder(
          builder: (BuildContext context) {
            return OfflineBuilder(
                connectivityBuilder: (BuildContext context,
                ConnectivityResult connectivity, Widget child) {
             connected =
                  connectivity != ConnectivityResult.none;
              return Stack(
                fit: StackFit.expand,
                children: [
                  child,
                  Positioned(
                    left: 0.0,
                    right: 0.0,
                    height: 32.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color:
                      connected!=true ? Colors.grey[900]:null,
                      child: connected !=true
                          ?  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "No connection",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          SizedBox(
                            width: 12.0,
                            height: 12.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                            ),
                          ),
                        ],
                      ):null,
                    ),
                  ),
                ],
              );
            },
            child:TabBarView(
              controller: tabController,

              physics: NeverScrollableScrollPhysics(),
            children: [
            PopularMovies(connected),
            TopMovies(connected),
            NowPlayingMovies(connected),
            ],
            ),
            );
          },
        )),

      );


  }
}
