import 'package:flutter/material.dart';

class Cover extends StatelessWidget {
  final String title;
  final String author;
  final String thumbnail;

  const Cover({
    super.key,
    required this.title,
    required this.author,
    required this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          width: 100,
            child: Column(
              children: [
                Image.network(
                  thumbnail,
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                author,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
        ),
      );
  }

}