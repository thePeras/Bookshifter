import 'package:app/api/Api.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage();

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

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
        // onPressed: () => Navigator.pushNamed(context, '/scanner'),
        onPressed: () async => print(await Api().getBook("great gatsby")),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
