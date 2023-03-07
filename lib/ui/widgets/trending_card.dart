import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:movie_app_assignment/model/movie_model.dart';
import 'package:movie_app_assignment/strings/strings.dart';
import 'package:movie_app_assignment/ui/movie_details.dart';

class TrendingNowCard extends StatelessWidget {
  final Movie? movie;

  const TrendingNowCard({Key? key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('MMMM d');
    final DateTime dateTime = DateTime.parse(movie!.releaseDate!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MovieDetailScreen(movie: movie, movieID: movie!.id!),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                var begin = Offset(0.0, 1.0);
                var end = Offset.zero;
                var curve = Curves.ease;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 30),
          height: 164,
          child: Card(
            color: const Color(0xFFF8F9FB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 5,
            child: Row(
              children: <Widget>[
                Hero(
                  tag: movie!.posterPath!,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                    height: 164,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500${movie?.posterPath}',
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          movie!.title!,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Color(0xFF000000),
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        sizedBox3(),
                        Container(
                          width: 240,
                          child: Text(
                            "${Strings.language}: ${movie!.originalLanguage == "en" ? "English" : ""}",
                            style: TextStyle(
                                fontSize: 14.0, color: Color(0xFF9E9CB1)),
                          ),
                        ),
                        sizedBox3(),
                        Container(
                            width: 240,
                            child: Text(
                              "${Strings.releaseDate}: ${formatter.format(dateTime)}",
                              style: TextStyle(
                                  fontSize: 14.0, color: Color(0xFF9E9CB1)),
                            )),
                        sizedBox3(),
                        RatingBar.builder(
                          initialRating:
                              (movie!.voteAverage! / 2).roundToDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20.0,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.blue,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sizedBox3() {
    return const SizedBox(
      height: 3,
    );
  }
}
