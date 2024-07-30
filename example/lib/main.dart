import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

double textSize = 20;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String firstButtonText = 'Take photo';
  String secondButtonText = 'Record video';

  String albumName = 'Media';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  child: SizedBox.expand(
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      onPressed: _takePhoto,
                      child: Text(firstButtonText, style: TextStyle(fontSize: textSize, color: Colors.white)),
                    ),
                  ),
                ),
              ),

              Flexible(
                child: Container(
                    child: SizedBox.expand(
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: _recordVideo,
                    child: Text(secondButtonText, style: TextStyle(fontSize: textSize, color: Colors.blueGrey)),
                  ),
                )),
                flex: 1,
              )
            ],
          ),
        ),
      ),
    ));
  }

  void _takePhoto() async {
    ImagePicker().pickImage(source: ImageSource.camera).then((XFile? recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        setState(() {
          firstButtonText = 'saving in progress...';
        });
        GallerySaver.saveImage(recordedImage.path, albumName: albumName).then((bool? success) {
          setState(() {
            firstButtonText = 'image saved!';
          });
        });
      }
    });
  }

  void _recordVideo() async {
    ImagePicker().pickVideo(source: ImageSource.camera).then((XFile? recordedVideo) {
      if (recordedVideo != null && recordedVideo.path != null) {
        setState(() {
          secondButtonText = 'saving in progress...';
        });

        GallerySaver.saveVideo(recordedVideo.path, albumName: albumName).then((bool? success) {
          setState(() {
            secondButtonText = 'video saved!';
          });
        });
      }
    });
  }

  // ignore: unused_element
  void _saveNetworkVideo() async {
    String path = 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
    GallerySaver.saveVideo(path, albumName: albumName).then((bool? success) {
      setState(() {
        print('Video is saved');
      });
    });
  }

  // ignore: unused_element
  void _saveNetworkImage() async {
    String path = 'https://image.shutterstock.com/image-photo/montreal-canada-july-11-2019-600w-1450023539.jpg';
    GallerySaver.saveImage(path, albumName: albumName).then((bool? success) {
      setState(() {
        print('Image is saved');
      });
    });
  }
}

