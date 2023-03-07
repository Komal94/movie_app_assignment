import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app_assignment/api_key/api_key.dart';
import 'package:movie_app_assignment/model/movie_model.dart';

class MovieService {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String nowPlayingEndpoint = '/movie/now_playing';
  static const String trendingEndpoint = '/trending/movie/week';
  static const String detailScreen = '/movie';

  Future<List<Movie>> getNowPlayingMovies(int page) async {
    final response = await http.get(Uri.parse(
      '$baseUrl$nowPlayingEndpoint?api_key=$apiKey&page=$page',
    ));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> results = json['results'];

      return results.map((result) => Movie.fromJson(result)).toList();
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  Future<List<Movie>> getTrendingMovies(int page) async {
    final response = await http.get(Uri.parse(
      '$baseUrl$trendingEndpoint?api_key=$apiKey&page=$page"',
    ));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> results = json['results'];

      return results.map((result) => Movie.fromJson(result)).toList();
    } else {
      throw Exception('Failed to load trending movies');
    }
  }

  Future<Movie> fetchMovie(int movieId) async {
    final response = await http
        .get(Uri.parse('$baseUrl$detailScreen/$movieId?api_key=$apiKey'));
    if (response.statusCode == 200) {
      return Movie.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<Movie> getMovieDetails(int movieId) async {
    final String url = '$baseUrl$detailScreen/$movieId?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }

  Future<List<dynamic>> getMovieReviews(int movieId, String apiKey) async {
    var url =
        Uri.parse('$baseUrl$detailScreen/$movieId/reviews?api_key=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse['results'];
    } else {
      throw Exception('Failed to load movie reviews');
    }
  }

  Future<List<dynamic>> getMovieCast(int movieId, String apiKey) async {
    var url =
        Uri.parse('$baseUrl$detailScreen/$movieId/credits?api_key=$apiKey');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse['cast'];
    } else {
      throw Exception('Failed to load movie cast list');
    }
  }

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final String url =
        '$baseUrl/movie/$movieId/similar?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> results = json['results'];

      return results.map((result) => Movie.fromJson(result)).toList();
    } else {
      throw Exception('Failed to fetch similar movies');
    }
  }

  Future<List<Map<String, dynamic>>> getMovieProductionCompanies(
      int movieId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl$detailScreen/$movieId?api_key=$apiKey&append_to_response=credits'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = json.decode(response.body);
      final List<Map<String, dynamic>> productionCompanies =
          List<Map<String, dynamic>>.from(
              decodedJson['credits']['production_companies']);
      final List<Map<String, dynamic>> companiesWithLogos = [];

      for (final company in productionCompanies) {
        final logoResponse = await http.get(Uri.parse(
            '$baseUrl${company['id']}?api_key=$apiKey&append_to_response=images'));
        final logoJson = json.decode(logoResponse.body);
        final List<dynamic> logos = logoJson['images']['logos'];
        final String? logoPath =
            logos.isNotEmpty ? logos[0]['file_path'] : null;
        company['logo_path'] = logoPath;
        companiesWithLogos.add(company);
      }

      return companiesWithLogos;
    } else {
      throw Exception('Failed to load production companies for movie $movieId');
    }
  }
}
