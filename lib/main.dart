
import 'package:flutter/material.dart';
import 'package:flutter_app3/imageupload.dart';
import 'package:flutter_app3/kamera.dart';
import 'gonder.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Okur v1.0',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red[700],
      ),
      initialRoute: "/",

      routes: {
        '/':(context)=>GonderWidget(),
        GonderWidget.pageRoute: (context) => GonderWidget(),
        KameraWidget.pageRoute:(context)=>KameraWidget("kamera"),
        MyAppImage.pageRoute:(context)=>MyAppImage(),
      },
    );
  }
}