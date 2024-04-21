import 'package:app/Widgets/bookCarousel.dart';
import 'package:app/model/BookScan.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PreviewScreen extends StatelessWidget {
  final String imagePath;
  final List<BookScan> scannedBooks;

  const PreviewScreen(
      {super.key, required this.imagePath, required this.scannedBooks});

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: _screenWidth,
            height: _screenWidth * 4 / 3,
            child: ClipRect(
                child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Container(
                            width: _screenWidth,
                            // Reflect vertically the Image.file(File(imagePath))
                            child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(3.1415926535),
                            child: Image.file(File(imagePath))))))),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.fromLTRB(0, 24, 0, 24),
            child: BookCarousel(
                books: scannedBooks
                    .map((scannedBook) => scannedBook.book)
                    .toList()),
          ))
        ],
      ),
    ));
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<BookScan> scannedBooks;

  BoundingBoxPainter(this.scannedBooks);

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width;
    final double scaleY = size.height;

    for (final book in scannedBooks) {
      final Map<String, dynamic>? boundingBox = book.boundingBox;

      if (boundingBox != null &&
          boundingBox.containsKey('left') &&
          boundingBox.containsKey('top') &&
          boundingBox.containsKey('right') &&
          boundingBox.containsKey('bottom')) {
        final Rect boundingRect = Rect.fromLTRB(
          boundingBox['left']! * scaleX,
          boundingBox['top']! * scaleY,
          boundingBox['right']! * scaleX,
          boundingBox['bottom']! * scaleY,
        );

        final Paint paint = Paint()
          ..color = Colors.transparent // Adjust as needed
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 // Adjust border width as needed
          ..shader = LinearGradient(
            colors: [Colors.white, Colors.white],
          ).createShader(boundingRect);

        canvas.drawRect(boundingRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
