import 'package:flutter/material.dart';
import 'package:mobile_app/screens/_home.screen.dart';
import 'package:mobile_app/utils/_app.constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      theme: ThemeData.dark(),
      // theme: ThemeData(
      //   primarySwatch: Colors.orange,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      darkTheme: ThemeData.dark(),
      home: MapSample(),
    );
  }
}

