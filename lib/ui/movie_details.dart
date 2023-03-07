import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:movie_app_assignment/model/movie_model.dart';
import 'package:movie_app_assignment/repository/movie_service.dart';
import 'package:movie_app_assignment/strings/strings.dart';
import 'package:movie_app_assignment/ui/similar%20movies.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieID;
  final Movie? movie;

  const MovieDetailScreen({Key? key, required this.movieID, this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Movie? movieData = Movie();
  final DateFormat formatter = DateFormat('MMMM d');
  late final DateTime dateTime;

  @override
  void initState() {
    super.initState();
    MovieService().getMovieDetails(widget.movie!.id!).then((value) {
      setState(() {
        movieData = value;
        dateTime =
            DateTime.parse(movieData != null ? movieData!.releaseDate! : "NA");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: movieData?.id != null
          ? Stack(
              children: [
                Hero(
                  tag: movieData!.posterPath!,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500${movieData?.posterPath}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  top: 0,
                  child: Container(
                    margin: EdgeInsets.only(top: 300),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: ListView(
                        children: [
                          Text(
                            movieData!.title!,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          RatingBar.builder(
                            initialRating:
                                (movieData!.voteAverage! / 2).roundToDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 30.0,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.blue,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 240,
                            child: Text(
                              "${Strings.language}: ${movieData?.originalLanguage == "en" ? "English" : ""}",
                              style: TextStyle(
                                  fontSize: 20.0, color: Color(0xFF9E9CB1)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              width: 240,
                              child: Text(
                                "${Strings.releaseDate}: ${formatter.format(dateTime)}",
                                style: TextStyle(
                                    fontSize: 20.0, color: Color(0xFF9E9CB1)),
                              )),
                          SizedBox(height: 13),
                          Container(
                              width: 240,
                              child: Text(
                                "${Strings.overview}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Color(0xFF000000)),
                              )),
                          SizedBox(height: 6),
                          Container(
                              child: Text(
                            "${movieData?.overview}",
                            style: TextStyle(
                                fontSize: 20.0, color: Color(0xFF9E9CB1)),
                          )),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                              width: 240,
                              child: Text(
                                "${Strings.productionHouse}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Color(0xFF000000)),
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            height: 50,
                            child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: movieData!.productionCompanies!
                                  .map((company) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 40),
                                  child: SizedBox(
                                    width: 150,
                                    height: 30,
                                    child: company.logoPath != null
                                        ? Image.network(
                                            'https://image.tmdb.org/t/p/w185${company.logoPath}',
                                            fit: BoxFit.fill,
                                          )
                                        : Icon(Icons.image_not_supported),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 163,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color(0xFF618CFF),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // Do something when button is pressed
                                  },
                                  child: Text(
                                    '${Strings.cast}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Container(
                                width: 163,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color(0xFF618CFF),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    // Do something when button is pressed
                                  },
                                  child: Text(
                                    '${Strings.review}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                              width: 240,
                              child: Text(
                                "${Strings.similarMovie}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Color(0xFF000000)),
                              )),
                          Container(
                              height: 300,
                              child:
                                  SimilarMoviesScreen(movieId: movieData!.id!))
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 50,
                    left: 30,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                    )),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
