import 'package:flutter/material.dart';
import 'package:pinch_zoom_image_updated/pinch_zoom_image_updated.dart';


class ResimDetay extends StatelessWidget {
  final String image;

  ResimDetay(this.image);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        centerTitle: true,
        title: Text("Test Okur v1.0"),
    ),
    body: Container(child:PinchZoomImage(
      image: Image.network(image),
      zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      hideStatusBarWhileZooming: true,
      onZoomStart: () {
        print('Zoom started');
      },
      onZoomEnd: () {
        print('Zoom finished');
      },
    ),
    ),

    );
}
}
