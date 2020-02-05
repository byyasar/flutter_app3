import 'package:flutter/material.dart';
import 'package:flutter_app3/kamera.dart';

class GonderWidget extends StatefulWidget {
  static final String pageRoute = '/gonder';

  @override
  _GonderWidgetState createState() => _GonderWidgetState();
}

class _GonderWidgetState extends State<GonderWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Test Okur v1.0"),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        //mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              color: Colors.red,
              child: RaisedButton(
                color: Colors.yellow,
                child: Text("Kameradan resim çek"),
                onPressed: () {
                  Navigator.of(context).pushNamed(KameraWidget.pageRoute);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
