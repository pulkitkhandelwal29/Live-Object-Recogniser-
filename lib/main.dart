import 'package:flutter/material.dart';
import './HomePage.dart';

Future<void> main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Recogniser App',
      home: HomePage(),
    );
  }
}
