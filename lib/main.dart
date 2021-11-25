import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_task/cubit/movie_cubit.dart';
import 'package:movie_task/layout/home_layout.dart';

import 'network/moviesapi.dart';
import 'network/obsever.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp(
repository: MoviesService(),
  ));
}

class MyApp extends StatelessWidget {
  final MoviesService repository;

  const MyApp({Key key, this.repository}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',


      home: BlocProvider(
          create:  (context) => MoviesCubit(repository),
          child: HomeLayout()),
    );
  }
}
