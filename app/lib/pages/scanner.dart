import 'dart:convert';
import 'dart:io';

import 'package:app/api/Api.dart';
import 'package:app/api/RekognitionHandler.dart';
import 'package:app/model/BookScan.dart';
import 'package:app/models/book.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/preview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_better_camera/camera.dart';
import 'package:path_provider/path_provider.dart';

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection? direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
    case null:
    // TODO: Handle this case.
  }
  throw ArgumentError('Unknown lens direction');
}

class ScannerPage extends StatefulWidget {
  final CameraDescription camera;
  const ScannerPage({super.key, required this.camera});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  CameraController? controller;
  String? imagePath;

  bool isLoading = false;
  String status = "";
  late RekognitionHandler _rekognition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    isLoading = false;
    _rekognition = RekognitionHandler();

    controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    controller!.addListener(() {
      if (mounted) setState(() {});
      if (controller!.value.hasError) {
        showInSnackBar('Camera error ${controller!.value.errorDescription}');
      }
    });

    controller!.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller!.value.isInitialized!) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {}
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: Column(children: [
        Stack(children: [
          SizedBox(
              width: _screenWidth,
              height: _screenWidth * 4 / 3,
              child: _cameraPreviewWidget()),
          if (isLoading)
            Positioned(
              top: _screenWidth * 4 / 3 / 2 - 10,
              left: _screenWidth / 2 - 20,
              child: const CircularProgressIndicator(),
            ),
          if (status != "") // Center text
            Positioned(
              top: _screenWidth * 4 / 3 / 2 - 50,
              left: _screenWidth / 2 - 50,
              child: Container(
                width: 300, // Set a fixed width for positioning
                child: Text(status,
                    textAlign: TextAlign.center, // Center text horizontally
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 22))),
              ),
            )
        ]),
        Expanded(
            child: Container(
          margin: const EdgeInsets.fromLTRB(0, 24, 0, 24),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // =======
                Text("Take a picture of a self\nto scan the books.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            color: Color(0xFF560FA9),
                            fontWeight: FontWeight.w600,
                            fontSize: 22))),
                // =======
                Text("Your books will be\ndisplayed here soon ",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16))),
                // =======
                ElevatedButton(
                  onPressed: scan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF560FA9),
                  ),
                  child: Text('Scan',
                      style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 22))),
                ),
              ]),
        )),
      ]),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized!) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller!.value.aspectRatio,
        child: CameraPreview(controller!),
      );
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    print("message: $message");
    //TODO: to implement
    //_scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(message)));
  }

  void toogleAutoFocus() {
    controller!.setAutoFocus(!controller!.value.autoFocusEnabled!);
    showInSnackBar('Toogle auto focus');
  }

  Future<String?> takePicture() async {
    if (!controller!.value.isInitialized!) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller!.value.isTakingPicture!) {
      // A capture is already pending, do nothing.
      return null;
    }

    await controller!.takePicture(filePath);

    return filePath;
  }

  void _showCameraException(CameraException e) {
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Future<List<BookScan>> detectBooks(String srcImage) async {
    File sourceImageFile = File(srcImage);

    Future<String> labelsArray = _rekognition.detectBooks(sourceImageFile);
    final List<dynamic> books = json.decode(await labelsArray)['Labels'];
    final int bookIndex =
        books.indexWhere((element) => element['Name'] == 'Book');
    if (bookIndex == -1) {
      print('No books found');
      return [];
    }

    final List<dynamic> booksInstances = books[bookIndex]['Instances'];
    print('Found ${booksInstances.length} books');
    setState(() {
      status = 'Found ${booksInstances.length} books';
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        if (isLoading) {
          status = 'Getting books info';
        }
      });
    });

    Future<String> textsArray = _rekognition.detectTexts(sourceImageFile);
    final List<dynamic> texts = json.decode(await textsArray)['TextDetections'];

    print('Found ${texts.length} texts');

    Future<List<BookScan>> createBookTextList(
        List booksData, List textsData) async {
      List<BookScan> bookTextList = [];

      booksData.sort((a, b) =>
          a['BoundingBox']['Left'].compareTo(b['BoundingBox']['Left']));

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
        final Book book = await Api.getBook(bookTexts.join(' '));
        if(book.title == "No book found") continue;
        
        bookTextList.add(BookScan(book, bookTexts, bookBbox));
      }

      return bookTextList;
    }

    return createBookTextList(booksInstances, texts);
  }

  void scan() async {
    setState(() => isLoading = true);

    print("About to take photo");
    takePicture().then((String? filePath) async {
      print("Photo taken");
      print(filePath);
      setState(() {
        imagePath = filePath;
      });

      if (filePath != null) showInSnackBar('Picture saved to $filePath');
      List<BookScan> scannedBooks = await detectBooks(filePath!);

      setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PreviewScreen(imagePath: filePath, scannedBooks: scannedBooks),
        ),
      );
    });
  }
}
