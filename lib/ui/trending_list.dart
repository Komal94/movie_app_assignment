import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app_assignment/model/movie_model.dart';
import 'package:movie_app_assignment/repository/movie_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app_assignment/ui/movie_details.dart';

class VerticalListView extends StatefulWidget {
  const VerticalListView();

  @override
  VerticalListViewState createState() => VerticalListViewState();
}

class VerticalListViewState extends State<VerticalListView> {
  final ScrollController _scrollController = ScrollController();
  final int _pageSize = 10;
  int _currentPage = 1;
  bool _isLoading = false;
  late List<Movie> trendingMovies = [];

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMovies() async {
    setState(() {
      _isLoading = true;
    });

    MovieService().getTrendingMovies(_currentPage).then((value) {
      setState(() {
        _isLoading = false;
        trendingMovies = value;
        _currentPage++;
      });
    });
    // Make API request to fetch movies
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 37, left: 20, right: 20),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: trendingMovies.length,
              itemBuilder: (BuildContext context, int index) {
                if (index < trendingMovies.length) {
                  return _buildMovieCard(index);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
    );
  }

  Widget _buildMovieCard(int index) {
    final DateFormat formatter = DateFormat('MMMM d');
    Movie movie = trendingMovies[index];
    final DateTime dateTime = DateTime.parse(movie.releaseDate!);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MovieDetailScreen(movie: movie, movieID: movie.id!),
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
                  tag: movie.posterPath!,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                    height: 164,
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}',
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
                          movie.title!,
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
                            "Language: ${movie.originalLanguage == "en" ? "English" : ""}",
                            style: TextStyle(
                                fontSize: 14.0, color: Color(0xFF9E9CB1)),
                          ),
                        ),
                        sizedBox3(),
                        Container(
                            width: 240,
                            child: Text(
                              "Release Date: ${formatter.format(dateTime)}",
                              style: TextStyle(
                                  fontSize: 14.0, color: Color(0xFF9E9CB1)),
                            )),
                        sizedBox3(),
                        RatingBar.builder(
                          initialRating:
                              (movie.voteAverage! / 2).roundToDouble(),
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
