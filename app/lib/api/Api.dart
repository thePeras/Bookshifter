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
    return bookInfo.map((book) => Book(
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
    )).toList();
  }
  static Future<Book> getBook(String query) async {
    var bookInfo = await books_finder.queryBooks(
      query,
      maxResults: 1,
      printType: books_finder.PrintType.books,
      orderBy: books_finder.OrderBy.relevance,
      reschemeImageLinks: true,
    );
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
        imageLinks: bookInfo[0].info.imageLinks,
        language: bookInfo[0].info.language,
    );
  }
}