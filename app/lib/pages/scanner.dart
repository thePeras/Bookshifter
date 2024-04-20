import 'dart:convert';
import 'dart:io';

import 'package:app/api/RekognitionHandler.dart';
import 'package:app/model/BookScan.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:app/pages/preview.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ScannerPage extends StatefulWidget {
  final CameraDescription camera;
  const ScannerPage({super.key, required this.camera});

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

  Future<List<BookScan>> detectBooks(String srcImage) async {
    File sourceImageFile = File(srcImage);

    String? accessKey = dotenv.env['PUBLIC'];
    String? secretKey = dotenv.env['SECRET'];
    String region = 'us-west-2';

    if(accessKey == null){
      print('Access key not found');
      return [];
    }
    if(secretKey == null){
      print('Secret key not found');
      return [];
    }

    RekognitionHandler rekognition =
        RekognitionHandler(accessKey, secretKey, region);
    Future<String> labelsArray = rekognition.detectBooks(sourceImageFile);
    final List<dynamic> books = json.decode(await labelsArray)['Labels'];
    final int bookIndex = books.indexWhere((element) => element['Name'] == 'Book');
    if (bookIndex == -1) {
      print('No books found');
      return [];
    }

    final List<dynamic> booksInstances = books[bookIndex]['Instances'];
    print('Found ${booksInstances.length} books');

    Future<String> textsArray = rekognition.detectTexts(sourceImageFile);
    final List<dynamic> texts = json.decode(await textsArray)['TextDetections'];

    List<BookScan> createBookTextList(List booksData,
        List textsData) {
      List<BookScan> bookTextList = [];

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

        //TODO: search the book by its texts
        bookTextList.add(BookScan("", bookTexts, bookBbox));
      }

      return bookTextList;
    }

    return createBookTextList(booksInstances, texts);
  }

  void scan() async {
    final XFile image = await controller.takePicture();
    List<BookScan> scannedBooks = await detectBooks(image.path);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PreviewScreen(imagePath: image.path, scannedBooks: scannedBooks),
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

