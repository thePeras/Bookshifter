import 'package:app/model/book.dart';

class BookDetection {
  final Book book;
  final List<String> texts;
  final Map<String, dynamic> boundingBox;

  BookDetection(this.book, this.texts, this.boundingBox);

  @override
  String toString() {
    return 'Book: $book, Texts: $texts, BoundingBox: $boundingBox';
  }

  Map<String, dynamic> toJson() {
    return {
      'book': book,
      'texts': texts,
      'boundingBox': boundingBox,
    };
  }
}