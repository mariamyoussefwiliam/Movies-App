import 'package:flutter/material.dart';
import 'package:movie_task/modules/popular%20movies.dart';
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
        body: TabBarView(
          children: [
           PopularMovies(),
            Center(child: Text('tab 2 '),),
            Center(child: Text('tab 3 '),),
          ],
        ),
      ),
    );
  }
}
