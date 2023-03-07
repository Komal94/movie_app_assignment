import 'package:flutter/material.dart';
import 'package:movie_app_assignment/strings/strings.dart';
import 'package:movie_app_assignment/ui/now_playing_list.dart';
import 'package:movie_app_assignment/ui/trending_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
                margin: const EdgeInsets.only(top: 63, left: 33.3),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                )),
            const HorizontalListViewPager(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 63, left: 33.3),
                    child: const Text(
                      Strings.trending,
                      style: TextStyle(
                          color: Color(0xFF0D0447),
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 63, right: 33.3),
                    child: const Text(
                      Strings.seeAll,
                      style: TextStyle(color: Color(0xFF618CFF), fontSize: 20),
                    )),
              ],
            ),
            const VerticalListView(),
          ],
        ),
      ),
    );
  }
}
