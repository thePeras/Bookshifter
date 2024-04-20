import 'dart:io';
import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;

  const PreviewScreen({super.key, required this.imagePath});

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
