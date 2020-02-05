import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class KameraWidget extends StatefulWidget {
  static final String pageRoute = "/kamera";

  @override
  _KameraWidgetState createState() => _KameraWidgetState();
}

@override
void initState() {
  // TODO: implement initState
}

class _KameraWidgetState extends State<KameraWidget> {
  File _image;
  bool _isButtonDisabled = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Görüntü Aktar"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        //color: Colors.red,
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              child: Text("Kamerayı Aç"),
              onPressed: () {
                _kameradanFotoCek();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2))),
            ),
            RaisedButton(
              child: Text("Galeriden Aç"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2))),
              onPressed: () {
                _galeridenResimSec();
              },
            ),

            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  image: new DecorationImage(
                fit: BoxFit.fill,
                image: _image == null
                    ? AssetImage('images/TEST.jpg')
                    : FileImage(_image),
              )),
            ),
            RaisedButton(
              child: Text("Gonder"),

                onPressed: _isButtonDisabled ==false? null : () {
                print("gönder tıklandı");
                },

            ),

          ],
        ),
      ),
    );
  }

  void _kameradanFotoCek() async {
    var _yeniResim = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = _yeniResim;
      _isButtonDisabled =true;
      //setState(() => _isButtonDisabled = !_isButtonDisabled);

      // Navigator.of(c_isButtonDisabled = !_isButtonDisabledontext).pop();
    });
  }

  void _galeridenResimSec() async {
    var _yeniResim = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = _yeniResim;
      _isButtonDisabled =true;
      //Navigator.of(context).pop();
    });
  }
}
