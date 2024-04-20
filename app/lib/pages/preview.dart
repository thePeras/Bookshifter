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
      body: Stack(
        children: [
          Image.file(File(imagePath)),
        ],
      ),
    );
  }
}