import 'package:flutter/material.dart';
import 'package:newsapp/screens/home.dart';
import 'package:newsapp/screens/new_view.dart';
import 'package:newsapp/screens/news_by_category.dart';
import 'package:newsapp/screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "News Application",
      debugShowCheckedModeBanner: false,
      routes: {
        "/home": (context) => Home(),
        "/new_view": (context) => NewView(),
        "/news_by_category": (context) => NewsByCategory(),
      },
      home: SplashScreen(),
    );
  }
}
