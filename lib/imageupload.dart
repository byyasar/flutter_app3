import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:toast/toast.dart';

//void main() => runApp(MyApp());
class MyAppImage extends StatelessWidget {
  static final String pageRoute = 'yukle';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Image Upload Demo',
        theme: ThemeData(primarySwatch: Colors.pink),
        home: ImageInput());
  }
}


class ImageInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImageInput();
  }
}

class _ImageInput extends State<ImageInput> {
  // To store the file provided by the image_picker
  File _imageFile;
  String _testSonuc;
  File sonucresimurl;

  // To track the file uploading state
  bool _isUploading = false;
  String sonuc = "";

  //String baseUrl = "http://192.168.43.161:5000";
  String resimUrl = "http://10.0.3.2:5000/static/sonuc/";
  String baseUrls = "http://10.0.3.2:5000/yukle";

  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = image;
    });
    // Closes the bottom sheet

  }

  Future<Map<String, dynamic>> _uploadImage(File image) async {
    setState(() {
      _isUploading = true;
    });
    // Find the mime type of the selected file by looking at the header bytes of the file
    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');
    // Intilize the multipart request
    final imageUploadRequest =
        http.MultipartRequest('POST', Uri.parse(baseUrls));
    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('file', image.path,
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
      debugPrint("test:" + _testSonuc);
      _resetState();
      //debugPrint(responseData.toString());
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
      Toast.show("Image Upload Failed!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Image Uploaded Successfully!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _resetState() {
    setState(() {
      _isUploading = false;
      _imageFile = null;
      sonucresimurl = File(_testSonuc);
    });
  }

  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    sonuc = "";
    sonucresimurl = null;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Camera'),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                FlatButton(
                  textColor: flatButtonColor,
                  child: Text('Use Gallery'),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget _buildUploadBtn() {
    Widget btnWidget = Container();
    if (_isUploading) {
      // File is being uploaded then show a progress indicator
      btnWidget = Container(
          margin: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator());
    } else if (!_isUploading && _imageFile != null) {
      // If image is picked by the user then show a upload btn
      btnWidget = Container(
        margin: EdgeInsets.only(top: 10.0),
        child: RaisedButton(
          child: Text('Upload'),
          onPressed: () {
            _startUploading();
          },
          color: Colors.pinkAccent,
          textColor: Colors.white,
        ),
      );
    }
    return btnWidget;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Image Upload Demo'),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.text,

                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: baseUrls,

                      labelText: "Sunucu İp Adresi",
                      prefixIcon: Icon(Icons.network_check),
                    ),
                    onSaved: (s)=>baseUrls=s,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
                    child: OutlineButton(
                      onPressed: () => _openImagePickerModal(context),
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 1.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.camera_alt),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Add Image'),
                        ],
                      ),
                    ),
                  ),
                  _imageFile == null
                      ? Text('Please pick an image')
                      : Image.file(
                    _imageFile,
                    fit: BoxFit.cover,
                    height: 300.0,
                    alignment: Alignment.topCenter,
                    width: MediaQuery.of(context).size.width,
                  ),
                  _buildUploadBtn(),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Sonuç:" + sonuc),
                  SizedBox(
                    width: 5.0,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.network(
                      //'http://10.0.3.2:5000/static/sonuc/157472b9aa854df4ad2f1a9df0cf2722.jpg',
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
                ],
              ),
            ),
          ],

        ),
      ),
    );
  }
}
