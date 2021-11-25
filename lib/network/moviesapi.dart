import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:movie_task/model/invaild%20api.dart';
import 'package:movie_task/model/movies.dart';

class Failure {
  String message;

  Failure(this.message);
}

class APIResult {
  bool hasError;
  dynamic data;
  Failure failure;
}

class MoviesService {
  Future<APIResult> popularMovies(int page) async {
    APIResult result = APIResult();
    Movies movieList = Movies();
    InvalidApi invalidApi;
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=5aaf1d917fc5f55d46614beda1e04bd5&language=en-US&page=$page'));

      if (response.statusCode == 200) {
        movieList = Movies.fromJson(jsonDecode(response.body));
        result.hasError = false;
        result.data = movieList;
      } else if (response.statusCode == 401) {
        invalidApi = InvalidApi.fromJson(jsonDecode(response.body));
        result.hasError = true;
        result.failure = Failure(invalidApi.stutas);
      } else if (response.statusCode == 404) {
        invalidApi = InvalidApi.fromJson(jsonDecode(response.body));
        result.hasError = true;
        result.failure = Failure(invalidApi.stutas);
      }
    } on FormatException {
      result.hasError = true;
      result.failure = Failure("Problem parsing data from the server");
    } on SocketException {
      result.hasError = true;
      result.failure = Failure("Can't connect to internet");
    } catch (ex) {
      result.hasError = true;
      result.failure = Failure(ex.toString());
    }
    return result;
  }

  Future<APIResult> topRatedMovies(int page) async {
    APIResult result = APIResult();
    Movies movieList = Movies();
    InvalidApi invalidApi;
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/top_rated?api_key=5aaf1d917fc5f55d46614beda1e04bd5&language=en-US&page=$page'));

      if (response.statusCode == 200) {
        movieList = Movies.fromJson(jsonDecode(response.body));
        result.hasError = false;
        result.data = movieList;
      } else if (response.statusCode == 401) {
        invalidApi = InvalidApi.fromJson(jsonDecode(response.body));
        result.hasError = true;
        result.failure = Failure(invalidApi.stutas);
      } else if (response.statusCode == 404) {
        invalidApi = InvalidApi.fromJson(jsonDecode(response.body));
        result.hasError = true;
        result.failure = Failure(invalidApi.stutas);
      }
    } on FormatException {
      result.hasError = true;
      result.failure = Failure("Problem parsing data from the server");
    } on SocketException {
      result.hasError = true;
      result.failure = Failure("Can't connect to internet");
    } catch (ex) {
      result.hasError = true;
      result.failure = Failure(ex.toString());
    }
    return result;
  }

  Future<APIResult> nowPlayingMovies(int page) async {
    APIResult result = APIResult();
    Movies movieList = Movies();
    InvalidApi invalidApi;
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/now_playing?api_key=5aaf1d917fc5f55d46614beda1e04bd5&language=en-US&page=$page'));

      if (response.statusCode == 200) {
        movieList = Movies.fromJson(jsonDecode(response.body));
        result.hasError = false;
        result.data = movieList;
      } else if (response.statusCode == 401) {
        invalidApi = InvalidApi.fromJson(jsonDecode(response.body));
        result.hasError = true;
        result.failure = Failure(invalidApi.stutas);
      } else if (response.statusCode == 404) {
        invalidApi = InvalidApi.fromJson(jsonDecode(response.body));
        result.hasError = true;
        result.failure = Failure(invalidApi.stutas);
      }
    } on FormatException {
      result.hasError = true;
      result.failure = Failure("Problem parsing data from the server");
    } on SocketException {
      result.hasError = true;
      result.failure = Failure("Can't connect to internet");
    } catch (ex) {
      result.hasError = true;
      result.failure = Failure(ex.toString());
    }
    return result;
  }
}
