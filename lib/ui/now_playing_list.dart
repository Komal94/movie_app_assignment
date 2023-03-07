import 'package:flutter/material.dart';
import 'package:movie_app_assignment/model/movie_model.dart';
import 'package:movie_app_assignment/repository/movie_service.dart';
import 'package:movie_app_assignment/ui/widgets/now_playing_card.dart';

class HorizontalListViewPager extends StatefulWidget {
  const HorizontalListViewPager();

  @override
  HorizontalListViewPagerState createState() => HorizontalListViewPagerState();
}

class HorizontalListViewPagerState extends State<HorizontalListViewPager> {
  late List<Movie> nowPlayingMovies = [];
  PageController _controller = PageController(viewportFraction: 1);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    MovieService().getNowPlayingMovies(1).then((value) {
      setState(() {
        nowPlayingMovies = value;
      });
      _controller = PageController(
        initialPage: _currentPage,
        viewportFraction: 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 37, left: 20, right: 20),
      height: 228.0,
      child: PageView.builder(
        controller: _controller,
        itemCount: nowPlayingMovies.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return _buildMovieCard(index);
        },
      ),
    );
  }

  Widget _buildMovieCard(int index) {
    Movie movie = nowPlayingMovies[index];
    return NowPlayingCard(movie: movie);
  }
}
