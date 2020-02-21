import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app3/buton_widget.dart';
import 'package:flutter_app3/kamera.dart';
import 'package:flutter_icons/flutter_icons.dart';

class GonderWidget extends StatefulWidget {
  static final String pageRoute = 'gonder';

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
      body: Container(
        //color: Colors.indigo.shade200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //verticalDirection: VerticalDirection.up,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        ButtonWidget(
                          butonText: "Kameradan resim çek",
                          butonIcon: Icon(MaterialIcons.camera,color: Colors.white,size: 32,),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KameraWidget("kamera"),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10,),
                        ButtonWidget(
                          butonText: "Galeriden resim seç",
                          butonIcon: Icon(MaterialIcons.image,color: Colors.white,size: 32,),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => KameraWidget("galeri"),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//MyAppImage
