import 'package:app/models/book.dart';
import 'package:app/pages/bookScanned.dart';
import 'package:app/widgets/cover.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class BookCarousel extends StatefulWidget {
  final List<Book> books;
  final void Function(int) changeIndex;

  const BookCarousel({super.key, required this.books, required this.changeIndex});

  @override
  State<BookCarousel> createState() => _BookCarouselState();
}

class _BookCarouselState extends State<BookCarousel> {
  @override
  Widget build(BuildContext context) {
    //no books found with some space around (padding)
    if (widget.books.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 70.0),
          child: Text('No books found'),
        ),
      );
    }

    return Swiper(
      onIndexChanged: (index) {
        widget.changeIndex(index);
      },
      layout: SwiperLayout.CUSTOM,
      customLayoutOption: CustomLayoutOption(startIndex: -1, stateCount: 3)
        ..addRotate([-45.0 / 180, 0.0, 45.0 / 180])
        ..addTranslate(
            [const Offset(-200.0, 20.0), const Offset(0.0, 0.0), const Offset(200.0, 20.0)]),
      itemWidth: 150.0,
      itemHeight: 250.0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookScannedPage(book: widget.books[index]))),
            child: Cover(
              title: widget.books[index].title,
              author: widget.books[index].authors.join(', '),
              thumbnail: widget.books[index].imageLinks['thumbnail']?.toString() ?? "https://www.labfriend.co.in/static/assets/images/shared/default-image.png"
            )
        );
      },
      itemCount: widget.books.length,
    );
  }
}
