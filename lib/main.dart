import 'package:flutter/material.dart';
import 'package:movie_app_assignment/strings/strings.dart';
import 'package:movie_app_assignment/ui/home_page.dart';
import 'package:movie_app_assignment/ui/now_playing_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: Strings.appTitle),
    );
  }
}
