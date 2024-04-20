import 'package:app/model/BookScan.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PreviewScreen extends StatelessWidget {
  final String imagePath;
  final List<BookScan> scannedBooks;

  const PreviewScreen({super.key, required this.imagePath, required this.scannedBooks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Result')),
        body: Column(
          children: [
            Stack(
              children: [
                Image.file(File(imagePath)),
                GestureDetector(
                  onTapUp: (TapUpDetails details) {
                    print("Touch detected at ${details.localPosition}");
                  },
                  child: CustomPaint(
                    painter: BoundingBoxPainter(scannedBooks),
                  ),
                ),
              ],
              
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scannedBooks.length,
                itemBuilder: (context, index) {
                  final BookScan scannedBook = scannedBooks[index];
                  return ListTile(
                    title: Text(scannedBook.book.title),
                    subtitle: Text(scannedBook.book.authors.join(', ')),
                  );
                },
              ),
            ),
          ],
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
