import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import './HomePage.dart';

class MySplashPage extends StatefulWidget {
  @override
  State<MySplashPage> createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 5,
        navigateAfterSeconds: HomePage(),
        imageBackground: Image.asset("assets/back.jpg").image,
        loaderColor: Colors.pink,
        loadingText: Text('Loading...', style: TextStyle(color: Colors.white)));
  }
}
