

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:movie_task/modules/popular%20movies.dart';
import 'package:movie_task/network/constants.dart';

import 'package:movie_task/network/moviesapi.dart';

class HomeLayout extends StatelessWidget {
  final MoviesService repository;

  const HomeLayout({Key key, this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black26,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Movies App"),
         centerTitle: true,
         bottom: TabBar(
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
                      connected!=true ? Color(0xFFEE4400):null,
                      child: connected !=true
                          ?  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "OFFLINE",
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
            children: [
            PopularMovies(connected),
            Center(child: Text('tab 2 '),),
            Center(child: Text('tab 3 '),),
            ],
            ),
            );
          },
        )),

      );


  }
}
