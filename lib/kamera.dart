import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class KameraWidget extends StatelessWidget {
  File _image;
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            child: Text("Kamerayı Aç"),
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
          ),
          RaisedButton(
            child: Text("Galeriden Aç"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            onPressed: () {},
          ),
          CircleAvatar(
            radius: 75,
            backgroundColor: Colors.white,
            backgroundImage: _image == null
                ? AssetImage('images/TEST.jpg')
                : FileImage(_image),
          ),
          RaisedButton(
            child: Text("Gonder"),
            onPressed: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RemoteApiKullanimi()));
              //Navigator.of(context).push(
              //  MaterialPageRoute(builder: (context) => GongerWidget()));
              print("resim gönderildi");
            },
          ),
        ],
      ),
    );
  }

}