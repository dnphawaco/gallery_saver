# Camera Content Saver for Flutter

Saves images and videos to device(Gallery and Photos)


## Installation

First, add `camera_content_saver` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### iOS

Add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

* `NSPhotoLibraryUsageDescription` - describe why your app needs permission for the photo library. This is called _Privacy - Photo Library Usage Description_ in the visual editor.

### Android

* `android.permission.WRITE_EXTERNAL_STORAGE` - Permission for usage of external storage

### Example

``` dart
import 'dart:io';

import 'package:camera_content_saver/camera_content_saver.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String firstButtonText = 'Take photo';
  String secondButtonText = 'Record video';
  double textSize = 20;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                child: SizedBox.expand(
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: _takePhoto,
                    child: Text(firstButtonText,
                        style:
                            TextStyle(fontSize: textSize, color: Colors.white)),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                  child: SizedBox.expand(
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: _recordVideo,
                  child: Text(secondButtonText,
                      style: TextStyle(
                          fontSize: textSize, color: Colors.blueGrey)),
                ),
              )),
              flex: 1,
            )
          ],
        ),
      ),
    ));
  }

  void _takePhoto() async {
    File recodedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    if (recodedImage != null && recodedImage.path != null) {
      setState(() {
        firstButtonText = 'saving in progress...';
      });
      await CameraContentSaver.saveImage(recodedImage.path);
      setState(() {
        firstButtonText = 'image saved!';
      });
    }
  }

  void _recordVideo() async {
    File recodedVideo = await ImagePicker.pickVideo(source: ImageSource.camera);
    if (recodedVideo != null && recodedVideo.path != null) {
      setState(() {
        secondButtonText = 'saving in progress...';
      });
      await CameraContentSaver.saveVideo(recodedVideo.path);
      setState(() {
        secondButtonText = 'video saved!';
      });
    }
  }
}

```