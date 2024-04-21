import 'dart:io';
import 'package:app/Widgets/bookCarousel.dart';
import 'package:app/model/BookScan.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;
  final List<BookScan> scannedBooks;

  const PreviewScreen(
      {super.key, required this.imagePath, required this.scannedBooks});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body:  Column(
          children: <Widget>[
            FittedBox(
              child: SizedBox(
                width: screenWidth,
                height: screenWidth * 4 / 3,
                // child: Image.file(File(imagePath)),
                child: CustomPaint(
                    foregroundPainter: BoundingBoxPainter(scannedBooks),
                    child: Image.file(File(imagePath)),
                )
            ),
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
    );
  }
}

class BoundingBoxPainter extends CustomPainter {
  final List<BookScan> scannedBooks;

  BoundingBoxPainter(this.scannedBooks);

  @override
  void paint(Canvas canvas, Size size) async {
    final double scaleX = size.width;
    final double scaleY = size.height;

    for (final book in scannedBooks) {
      final Map<String, dynamic> boundingBox = book.boundingBox;

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
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawRect(boundingRect, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
