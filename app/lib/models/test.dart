import 'package:app/api/Api.dart';
import '../models/book.dart';

Future<List<Future<Book>>> fetchBooks(List<String> titles) async {
  return titles.map((title) async => await Api.getBook(title)).toList();
}

void main() {
  var books = ["A Ilha do Tesouro", "A Malnascida", "Robinson Crusoé", "O Conde de Monte Cristo", "The Alchemist", "1984", "The Great Gatsby"];
  fetchBooks(books).then((value) {
    for (var element in value) {
      element.then((value) {
        print(value.imageLinks["thumbnail"]);
      });
    }
  });
}
