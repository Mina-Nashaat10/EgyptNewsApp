import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/screens/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        backgroundColor: Colors.lightBlueAccent,
        splash: SizedBox(
          width: 300,
          height: 400,
          child: Image.asset(
            "assets/images/splash_screen.png",
            fit: BoxFit.fill,
          ),
        ),
        nextScreen: Home(),
        splashTransition: SplashTransition.slideTransition,
        duration: 3000,
      ),
    );
  }
}
