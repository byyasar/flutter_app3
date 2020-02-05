import 'package:flutter/material.dart';

class GongerWidget extends StatefulWidget {
  @override
  _GongerWidgetState createState() => _GongerWidgetState();
}

class _GongerWidgetState extends State<GongerWidget> {
  @override
  const
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
