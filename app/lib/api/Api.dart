import "package:books_finder/books_finder.dart" as books_finder;
import 'package:app/models/book.dart';

class Api {
  static Future<List<Book>> getBooks(String query) async {
    var bookInfo = await books_finder.queryBooks(
      query,
      maxResults: 3,
      printType: books_finder.PrintType.books,
      orderBy: books_finder.OrderBy.relevance,
      reschemeImageLinks: true,
    );
    return bookInfo
        .map((book) => Book(
              title: book.info.title,
              subtitle: book.info.subtitle,
              authors: book.info.authors,
              publisher: book.info.publisher,
              publishedDate: book.info.publishedDate,
              rawPublishedDate: book.info.rawPublishedDate,
              description: book.info.description,
              pageCount: book.info.pageCount,
              categories: book.info.categories,
              averageRating: book.info.averageRating,
              ratingsCount: book.info.ratingsCount,
              maturityRating: book.info.maturityRating,
              contentVersion: book.info.contentVersion,
              industryIdentifier: book.info.industryIdentifiers,
              imageLinks: book.info.imageLinks,
              language: book.info.language,
            ))
        .toList();
  }

  static Future<Book> getBook(String query) async {
    
    if(query.isEmpty){
      return Book(
        title: 'No book found',
        subtitle: '',
        authors: [],
        publisher: '',
        publishedDate: DateTime.now(),
        rawPublishedDate: '',
        description: '',
        pageCount: 0,
        categories: [],
        averageRating: 0,
        ratingsCount: 0,
        maturityRating: '',
        contentVersion: '',
        industryIdentifier: [],
        imageLinks: {
          "thumbnail": Uri.parse(
              "https://www.labfriend.co.in/static/assets/images/shared/default-image.png"),
        },
        language: '',
      );
    }

    var bookInfo = await books_finder.queryBooks(
      query,
      maxResults: 1,
      printType: books_finder.PrintType.books,
      orderBy: books_finder.OrderBy.relevance,
      reschemeImageLinks: true,
    );

    if (bookInfo.isEmpty) {
      return Book(
        title: 'No book found',
        subtitle: '',
        authors: [],
        publisher: '',
        publishedDate: DateTime.now(),
        rawPublishedDate: '',
        description: '',
        pageCount: 0,
        categories: [],
        averageRating: 0,
        ratingsCount: 0,
        maturityRating: '',
        contentVersion: '',
        industryIdentifier: [],
        imageLinks: {
          "thumbnail": Uri.parse(
              "https://www.labfriend.co.in/static/assets/images/shared/default-image.png"),
        },
        language: '',
      );
    }

    // Because google books api doesn't have this image
    Uri? thumbnail = bookInfo[0].info.imageLinks["thumbnail"];
    if(bookInfo[0].info.title == "Sob águas escuras") thumbnail = Uri.parse("https://img.wook.pt/images/aguas-profundas-robert-bryndza/MXwyMTI5NDgzNXwxNzE4MDU5MXwxNTE1NTgxNTQxMDAw/500x");
    if(bookInfo[0].info.title == "Histórias para princesas") thumbnail = Uri.parse("https://static.fnac-static.com/multimedia/Images/PT/NR/b7/fa/04/326327/1540-6/tsp20160818163758/Historias-de-Princesas.jpg");
    RegExp regex = RegExp(r'\b(bíblia|biblia)\b', caseSensitive: false);
    if(regex.hasMatch(bookInfo[0].info.title)) thumbnail = Uri.parse("https://images-na.ssl-images-amazon.com/images/I/91kM77X%2BolL.jpg");

    final Map<String, Uri> imageLinks = {};
    if(thumbnail != null) imageLinks.addAll({"thumbnail": thumbnail});

    return Book(
      title: bookInfo[0].info.title,
      subtitle: bookInfo[0].info.subtitle,
      authors: bookInfo[0].info.authors,
      publisher: bookInfo[0].info.publisher,
      publishedDate: bookInfo[0].info.publishedDate,
      rawPublishedDate: bookInfo[0].info.rawPublishedDate,
      description: bookInfo[0].info.description,
      pageCount: bookInfo[0].info.pageCount,
      categories: bookInfo[0].info.categories,
      averageRating: bookInfo[0].info.averageRating,
      ratingsCount: bookInfo[0].info.ratingsCount,
      maturityRating: bookInfo[0].info.maturityRating,
      contentVersion: bookInfo[0].info.contentVersion,
      industryIdentifier: bookInfo[0].info.industryIdentifiers,
      imageLinks: imageLinks,
      language: bookInfo[0].info.language,
    );
  }
}
