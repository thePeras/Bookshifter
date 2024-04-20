import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/books/v1.dart' as books;


class LandingPage extends StatefulWidget {
  final AuthClient client;

  const LandingPage({super.key, required this.client});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  // Example here
  void getBookShelfs() async {
    final shelfs = await books.BooksApi(widget.client).mylibrary.bookshelves.list();
    //for each bookshelfs print its name
    for (final shelf in shelfs.items!) {
      print(shelf.title);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("BookShifter"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/scanner'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
