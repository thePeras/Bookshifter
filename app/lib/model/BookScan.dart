class BookScan {
  final String book;
  final List<String> texts;
  final Map<String, dynamic> boundingBox;

  BookScan(this.book, this.texts, this.boundingBox);

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