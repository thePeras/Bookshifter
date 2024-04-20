import 'dart:io';
import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;
  final books;
  final texts;

  const PreviewScreen({super.key, required this.imagePath, required this.books, required this.texts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
