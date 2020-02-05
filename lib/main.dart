
import 'package:flutter/material.dart';

import 'gonder.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turkish Airlines - (Clone)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red[700],
      ),
      home: GonderWidget(),
      routes: {
        GonderWidget.pageRoute: (context) => GonderWidget(),
      },
    );
  }
}