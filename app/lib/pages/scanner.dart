import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:app/pages/preview.dart';
import 'package:googleapis/vision/v1.dart' as vision;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:developer';

class ScannerPage extends StatefulWidget {
  final CameraDescription camera;
  final AuthClient client;
  const ScannerPage({super.key, required this.camera, required this.client});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void scan() async {
    try {
      final XFile image = await controller.takePicture();

      final vision.BatchAnnotateImagesRequest request = vision.BatchAnnotateImagesRequest.fromJson({
        "requests": [
          {
            "image": {"content": base64Encode(await image.readAsBytes())},
            "features": [
              {"type": "OBJECT_LOCALIZATION", "maxResults": 20},
              {"type": "TEXT_DETECTION"}
            ]
          }
        ]
      });
      final vision.BatchAnnotateImagesResponse result = await vision.VisionApi(widget.client).images.annotate(request);

      for (final response in result.responses!) {
        print(json.encode(response));
      }

      //Navigator.push(
      //  context,
      //  MaterialPageRoute(
      //    builder: (context) => PreviewScreen(imagePath: image.path),
      //  ),
      //);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("BookShifter"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: CameraPreview(controller),
            ),
            ElevatedButton(
              onPressed: scan,
              child: const Text('Take Picture'),
            ),
          ],
        ),
      ),
    );
  }
}
