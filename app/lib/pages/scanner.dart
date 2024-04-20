import 'dart:convert';
import 'dart:io';

import 'package:app/api/RekognitionHandler.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:app/pages/preview.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

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

  Future<void> detectTheFace(String srcImage) async {
    File sourceImageFile = File(srcImage);

    String credsString = await rootBundle.loadString('assets/env.json');
    final decodedCreds = json.decode(credsString);

    String accessKey = decodedCreds["public"];
    String secretKey = decodedCreds["private"];
    String region = 'us-west-2';

    RekognitionHandler rekognition =
        RekognitionHandler(accessKey, secretKey, region);
    Future<String> labelsArray = rekognition.detectBooks(sourceImageFile);
    final List<dynamic> books = json.decode(await labelsArray)['Labels'];
    final int bookIndex = books.indexWhere((element) => element['Name'] == 'Book');
    if (bookIndex == -1) {
      print('No books found');
      return;
    }

    final List<dynamic> booksInstances = books[bookIndex]['Instances'];
    print('Found ${booksInstances.length} books');

    Future<String> textsArray = rekognition.detectTexts(sourceImageFile);
    final List<dynamic> texts = json.decode(await textsArray)['TextDetections'];

    List<BookText> createBookTextList(List booksData,
        List textsData) {
      List<BookText> bookTextList = [];

      for (var bookInfo in booksData) {
        List<String> bookTexts = [];

        var bookBbox = bookInfo['BoundingBox'];

        for (var textInfo in textsData) {
          String text = textInfo['DetectedText'];
          var bbox = textInfo['Geometry']['BoundingBox'];

          if (bbox['Left'] > bookBbox['Left'] &&
              bbox['Top'] > bookBbox['Top'] &&
              bbox['Left'] + bbox['Width'] <
                  bookBbox['Left'] + bookBbox['Width'] &&
              bbox['Top'] + bbox['Height'] <
                  bookBbox['Top'] + bookBbox['Height']) {
            bookTexts.add(text);
          }
        }

        bookTextList.add(BookText("", bookTexts, bookBbox));
      }

      return bookTextList;
    }

    List<BookText> result = createBookTextList(booksInstances, texts);
    print(result);
  }

  void scan() async {
    final XFile image = await controller.takePicture();
    await detectTheFace(image.path);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PreviewScreen(imagePath: image.path, books: [], texts: []),
      ),
    );
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

class BookText {
  final String book;
  final List<String> texts;
  final Map<String, dynamic> boundingBox;

  BookText(this.book, this.texts, this.boundingBox);

  @override
  String toString() {
    return 'Book: $book, Texts: $texts, BoundingBox: $boundingBox';
  }

  Map<String, dynamic> toJson() {
    return {
      'book': book,
      'texts': texts,
      'boundingBox': boundingBox,
    };
  }
}
