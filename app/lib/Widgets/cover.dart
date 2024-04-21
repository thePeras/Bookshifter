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
    return Container(
          width: 100,
          height: null,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              children: [
                Image.network(
                  thumbnail,
                  width: 150,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 15,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: 25,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    author,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
            ],
        ),
      );
  }

}