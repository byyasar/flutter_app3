import 'package:flutter/material.dart';

class GonderWidget extends StatefulWidget {
  static final String pageRoute='/gonder';
  @override
  _GonderWidgetState createState() => _GonderWidgetState();
}

class _GonderWidgetState extends State<GonderWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gönder"),
      ),
      body: Container(
        width: 200,
        height: 200,
        color: Colors.red,
      ),
    );
  }
}
