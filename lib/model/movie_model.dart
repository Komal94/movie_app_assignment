import 'package:movie_app_assignment/model/production_companies.dart';

class Movie {
  final int? id;
  final String? title;
  final String? overview;
  final String? posterPath;
  final String? releaseDate;
  final dynamic voteAverage;
  final String? originalLanguage;
  List<ProductionCompany>? productionCompanies;

  Movie(
      {this.id,
      this.title,
      this.overview,
      this.posterPath,
      this.releaseDate,
      this.voteAverage,
      this.originalLanguage,
      this.productionCompanies});

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<ProductionCompany> productionCompanies = [];
    if (json['production_companies'] != null) {
      json['production_companies'].forEach((company) {
        productionCompanies.add(ProductionCompany.fromJson(company));
      });
    }

    return Movie(
        id: json['id'],
        title: json['title'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        releaseDate: json['release_date'],
        voteAverage: json['vote_average'],
        originalLanguage: json['original_language'],
        productionCompanies: productionCompanies);
  }
}
