import 'dart:convert';
import 'dart:io';

import 'package:app/api/RekognitionHandler.dart';
import 'package:app/model/BookScan.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:app/pages/preview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            // =========================
            // =========================
            // CLIP CAMERA
            // =========================
            (controller.value.isInitialized) ? SizedBox(
              width: screenWidth,
              height: screenWidth * 4 / 3,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: SizedBox(
                      width: screenWidth,
                      child: CameraPreview(controller)
                    )
                  )
                )
              ),
            ) : GestureDetector(
              onTap: () { },
              child: Container(
                color: Colors.red,
                width: screenWidth,
                height: screenWidth * 4 / 3,
              )
            ),
            // =========================
            // =========================
            // after camera
            // =========================
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 24, 0, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // =======
                    Text(
                      "Take a picture of a self\nto scan the books.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(color: Color(0xFF560FA9), fontWeight: FontWeight.w600, fontSize: 22)
                      )
                    ),
                    // =======
                    Text(
                      "Your books will be\ndisplayed here soon ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16)
                      )
                      ),
                    // =======
                    ElevatedButton(
                      onPressed: scan,
                      child: const Text('Take Picture'),
                    ),
                    ElevatedButton(
                      onPressed: () {Navigator.pushNamed(context, '/bookscanned');},
                      child: const Text("REMOVE ESTE BOTÃO (TESTE)"),
                    )
                  ]
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

