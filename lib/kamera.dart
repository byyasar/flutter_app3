import 'package:flutter/material.dart';
import 'package:flutter_app3/buton_widget.dart';
import 'package:flutter_app3/resimdetayPage.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:toast/toast.dart';

class KameraWidget extends StatefulWidget {
  static final String pageRoute = "kamera";
  String yer = "kamera";

  KameraWidget(this.yer);

  @override
  _KameraWidgetState createState() => _KameraWidgetState();
}

class _KameraWidgetState extends State<KameraWidget> {
  bool _isButtonDisabled = false;
  File _imageFile;
  bool _isUploading = false;
  String sonuc = "";
  String _testSonuc;

  //http://192.168.43.161:5000/
  String resimUrl = "http://10.0.3.2:5000/static/sonuc/";
  String baseUrls = "http://10.0.3.2:5000/yukle";
  File sonucresimurl = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      // _kameradanFotoCek();
      debugPrint('init ');
      sonuc = "";
      //_galeridenResimSec();
      widget.yer == "kamera" ? _kameradanFotoCek() : _galeridenResimSec();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Görüntü Aktar"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          setState(() {
            sonuc = "";
            sonucresimurl = null;
          });
          debugPrint(widget.yer);
          widget.yer == "kamera" ? _kameradanFotoCek() : _galeridenResimSec();
        },
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.grey,
            padding: EdgeInsets.all(30),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: _imageFile == null
                        ? AssetImage('images/TEST.jpg')
                        : FileImage(_imageFile),
                  )),
                ),
                ButtonWidget(
                  butonText: "Testi Gönder",
                  butonIcon: Icon(
                    MaterialIcons.send,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: _isButtonDisabled == false
                      ? null
                      : () async {
                          _startUploading();
                        },
                ),
                SizedBox(
                  width: 5.0,
                ),
                GestureDetector(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(
                      //'http://10.0.3.2:5000/static/sonuc/0d9f18ca746b489d8a3fffd355cce0dc.jpg',
                      sonucresimurl == null
                          ? AssetImage('images/TEST.jpg').toString()
                          : _testSonuc,
                      scale: 2,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResimDetay(_testSonuc),
                      ),
                    );
                  }
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Sonuç:" + sonuc),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _uploadImage(File image) async {
    setState(() {
      _isUploading = true;
    });
    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
        lookupMimeType(_imageFile.path, headerBytes: [0xFF, 0xD8]).split('/');
    // Intilize the multipart request
    final imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse(baseUrls));
    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('file', _imageFile.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    //contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension
    //imageUploadRequest.fields['ext'] = mimeTypeData[1];
    imageUploadRequest.files.add(file);
    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        print(response.statusCode.toString());
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      sonuc = "\n" +
          responseData['ogrno'].toString() +
          "\n" +
          responseData['puan'].toString() +
          "\n" +
          responseData['cevapanahtari'].toString() +
          "\n" +
          responseData['ogrencicevaplar'].toString() +
          "\n" +
          responseData['cevapdurum'].toString() +
          "\n";
      _testSonuc = resimUrl + responseData['resim'];
      _resetState();

      setState(() {
        debugPrint(responseData.toString());
      });
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _startUploading() async {
    final Map<String, dynamic> response = await _uploadImage(_imageFile);
    print(response);
    // Check if any error occured
    if (response == null || response.containsKey("error")) {
      Toast.show("Resim yükleme hatası!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Resim yükleme başarılı!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _kameradanFotoCek() async {
    var _yeniResim = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _imageFile = _yeniResim;
      _isButtonDisabled = true;
    });
  }

  void _galeridenResimSec() async {
    var _yeniResim = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = _yeniResim;
      _isButtonDisabled = true;
      debugPrint('_isButtonDisabled $_isButtonDisabled');
    });
  }

  void _resetState() {
    debugPrint('_isButtonDisabled $_isButtonDisabled');

    _isButtonDisabled = false;
    sonucresimurl = File(_testSonuc);
    debugPrint(_testSonuc);
  }
}
