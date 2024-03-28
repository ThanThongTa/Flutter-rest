// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restapi/screens/screen1.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MainApp());
}

//projekt zum laufen bringen
//2. screen erstellen und Photos darstellen (aus dem jsson placeholder)

//^ Learnings
//^ use https://app.quicktype.io/ to create classes from JSON
//^ use https://jsonplaceholder.typicode.com/ to get placeholder posts / photos / etc.
//^ GridView Builder needs a size constraints, use shrinkWrap
//^ add SingleChildScrollView to get rid of the bottom overflow
//^ use lazy loading for the photos because there are so many (5000)

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Rest API with Flutter",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Screen1(),
      );
    });
  }
}
