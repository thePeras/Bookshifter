import "package:books_finder/books_finder.dart" as books_finder;

class Book {
  final String title;
  final String subtitle;
  final List<String> authors;
  final String publisher;
  final DateTime? publishedDate;
  final String rawPublishedDate;
  final String description;
  final int pageCount;
  final List<String> categories;
  final double averageRating;
  final int ratingsCount;
  final String maturityRating;
  final String contentVersion;
  final List<books_finder.IndustryIdentifier> industryIdentifier;
  final Map<String, Uri> imageLinks;
  final String language;

  Book({
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.rawPublishedDate,
    required this.description,
    required this.pageCount,
    required this.categories,
    required this.averageRating,
    required this.ratingsCount,
    required this.maturityRating,
    required this.contentVersion,
    required this.industryIdentifier,
    required this.imageLinks,
    required this.language,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
    'authors': authors,
    'publisher': publisher,
    'publishedDate': publishedDate,
    'rawPublishedDate': rawPublishedDate,
    'description': description,
    'pageCount': pageCount,
    'categories': categories,
    'averageRating': averageRating,
    'ratingsCount': ratingsCount,
    'maturityRating': maturityRating,
    'contentVersion': contentVersion,
    'industryIdentifier': industryIdentifier,
    'imageLinks': imageLinks,
    'language': language,
  };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Book && runtimeType == other.runtimeType && title == other.title;
  }
  @override
  int get hashCode => title.hashCode;
}
