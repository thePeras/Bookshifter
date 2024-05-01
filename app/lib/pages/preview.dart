import 'dart:io';
import 'package:app/widgets/carousel.dart';
import 'package:app/model/book_detection.dart';
import 'package:flutter/material.dart';

class PreviewPage extends StatefulWidget {
  final String imagePath;
  final List<BookDetection> scannedBooks;

  const PreviewPage(
      {super.key, required this.imagePath, required this.scannedBooks});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late String imagePath;
  late List<BookDetection> scannedBooks;
  int index = 0;

  @override
  void initState() {
    super.initState();
    imagePath = widget.imagePath;
    scannedBooks = widget.scannedBooks;
  }

  void changeIndex(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: <Widget>[
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
                width: screenWidth,
                height: screenWidth * 4 / 3,
                // child: Image.file(File(imagePath)),
                child: CustomPaint(
                  foregroundPainter: BoundingBoxPainter(scannedBooks, index),
                  child: Image.file(File(imagePath)),
                )),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: BookCarousel(
                changeIndex: changeIndex,
                books: scannedBooks
                    .map((scannedBook) => scannedBook.book)
                    .toList()),
          ))
        ],
      ),
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<BookDetection> scannedBooks;
  final int index;

  BoundingBoxPainter(this.scannedBooks, this.index);

  @override
  void paint(Canvas canvas, Size size) async {
    final double scaleX = size.width;
    final double scaleY = size.height;

    for (int i = 0; i < scannedBooks.length; i++) {

      final Map<String, dynamic> boundingBox = scannedBooks[i].boundingBox;

      if (boundingBox.containsKey('Height') &&
          boundingBox.containsKey('Left') &&
          boundingBox.containsKey('Top') &&
          boundingBox.containsKey('Width')) {
        final Rect boundingRect = Rect.fromLTWH(
          boundingBox['Left']! * scaleX,
          boundingBox['Top']! * scaleY,
          boundingBox['Width']! * scaleX,
          boundingBox['Height']! * scaleY,
        );

      
        final Paint paint = Paint()
          ..color = i != index ? Colors.white : const Color(0xFF560FA9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

        canvas.drawRect(boundingRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
