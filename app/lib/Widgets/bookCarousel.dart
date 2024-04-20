import 'package:app/widgets/cover.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';

class BookCarousel extends StatefulWidget {
  int index;
  final List<Book> books;
  BookCarousel({super.key, this.index = 0, required this.books});

  @override
  State<BookCarousel> createState() => _BookCarouselState();
}

class _BookCarouselState extends State<BookCarousel> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (widget.index > 0)
            ? Cover(
                title: widget.books[widget.index - 1].title,
                thumbnail: widget.books[widget.index - 1].imageLinks['thumbnail'].toString(),
                author: widget.books[widget.index - 1].authors.join(', '),
              )
            : const SizedBox(),
        Expanded(
          child: Cover(
            title: widget.books[widget.index].title,
            thumbnail: widget.books[widget.index].imageLinks['thumbnail'].toString(),
            author: widget.books[widget.index].authors.join(', '),
            incline: 0,
          ),
        ),
        (widget.index < widget.books.length - 1)
            ? Cover(
                title: widget.books[widget.index + 1].title,
                thumbnail: widget.books[widget.index + 1].imageLinks['thumbnail'].toString(),
                author: widget.books[widget.index + 1].authors.join(', '),
              )
            : const SizedBox(),
      ]
    );
  }

}