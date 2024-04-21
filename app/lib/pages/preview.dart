import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
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
      body: Center(
        child: Column(
          children: <Widget>[
            FittedBox(
              child: SizedBox(
                width: screenWidth,
                height: screenWidth * 4 / 3,
                child: CustomPaint(
                  painter: BoundingBoxPainter(imagePath, scannedBooks),
                ),
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
    ));
  }
}

class BoundingBoxPainter extends CustomPainter {
  final String imagePath;
  final List<BookScan> scannedBooks;

  BoundingBoxPainter(this.imagePath, this.scannedBooks);

  @override
  void paint(Canvas canvas, Size size) async {
    final double scaleX = size.width;
    final double scaleY = size.height;
    final ui.Image image = await loadImage(imagePath);

    canvas.drawImage(image, Offset.zero, Paint());
    /*for (final book in scannedBooks) {
      final Map<String, dynamic> boundingBox = book.boundingBox;

      print(boundingBox);

      if (boundingBox.containsKey('left') &&
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
          ..shader = const LinearGradient(
            colors: [Colors.green, Colors.green],
          ).createShader(boundingRect);

        canvas.drawRect(boundingRect, paint);
      }
    }*/
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  Future<ui.Image> loadImage(String imagePath) async {
    final File imageFile = File(imagePath);
    final Uint8List bytes = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.Image image = (await codec.getNextFrame()).image;
    return image;
  }
}
