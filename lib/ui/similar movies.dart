import 'package:flutter/material.dart';
import 'package:movie_app_assignment/model/movie_model.dart';
import 'package:movie_app_assignment/repository/movie_service.dart';
import 'package:movie_app_assignment/ui/movie_details.dart';

class SimilarMoviesScreen extends StatefulWidget {
  final int movieId;

  SimilarMoviesScreen({required this.movieId});

  @override
  _SimilarMoviesScreenState createState() => _SimilarMoviesScreenState();
}

class _SimilarMoviesScreenState extends State<SimilarMoviesScreen> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = MovieService().getSimilarMovies(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          MovieDetailScreen(
                              movie: snapshot.data![index],
                              movieID: snapshot.data![index].id!),
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
                child: Hero(
                  tag: snapshot.data![index].posterPath!,
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20, right: 20),
                    height: 219,
                    width: 148,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500${snapshot.data![index].posterPath!}',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load similar movies'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
