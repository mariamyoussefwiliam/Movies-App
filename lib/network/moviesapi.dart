
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_task/model/movies.dart';
class MoviesService
{
  Future<Movies> popularMovies(int page) async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/popular?api_key=5aaf1d917fc5f55d46614beda1e04bd5&language=en-US&page=$page'));

    if(response.statusCode==200){
      return Movies.fromJson(jsonDecode(response.body));
    }
    else
    {
      throw Exception('failed to get popular Movies data');
    }
  }

  Future<Movies> topRatedMovies(int page) async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/top_rated?api_key=5aaf1d917fc5f55d46614beda1e04bd5&language=en-US&page=$page'));

    if(response.statusCode==200){
      // print(response.body);
      return Movies.fromJson(jsonDecode(response.body));
    }
    else
    {
      throw Exception('failed to get Top Rated Movies data');
    }
  }

  Future<Movies> nowPlayingMovies(int page) async {
    final response = await http.get(Uri.parse('https://api.themoviedb.org/3/movie/now_playing?api_key=5aaf1d917fc5f55d46614beda1e04bd5&language=en-US&page=$page'));

    if(response.statusCode==200){
      // print(response.body);
      return Movies.fromJson(jsonDecode(response.body));
    }
    else
    {
      throw Exception('failed to get Now Playing Movies data');
    }
  }

}
