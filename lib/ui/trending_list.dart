import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app_assignment/model/movie_model.dart';
import 'package:movie_app_assignment/repository/movie_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_app_assignment/ui/movie_details.dart';
import 'package:movie_app_assignment/ui/widgets/trending_card.dart';

class VerticalListView extends StatefulWidget {
  const VerticalListView();

  @override
  VerticalListViewState createState() => VerticalListViewState();
}

class VerticalListViewState extends State<VerticalListView> {
  final ScrollController _scrollController = ScrollController();
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
    Movie movie = trendingMovies[index];

    return TrendingNowCard(movie: movie);
  }
}
