import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../lib/files.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('gallery_saver');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'saveImage':
          return true;
        case 'saveVideo':
          return false;
      }
      return 'unknown method';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('save image', () async {
    expect(await GallerySaver.saveImage('/storage/emulated/image.jpg'), true);
  });

  test('save video', () async {
    expect(await GallerySaver.saveVideo('/storage/emulated/video.mov'), false);
  });

  test('disregard query string for image', () {
    const String url = "https://placeholder.com/400x400.jpg?remove=true";
    expect(isImage(url), true);
  });

  test('disregard query string for video', () {
    const String url = "https://placeholder.com/400x400.mov?remove=true";
    expect(isVideo(url), true);
  });
}
