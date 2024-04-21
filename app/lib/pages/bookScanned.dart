import 'package:app/models/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class BookScannedPage extends StatelessWidget {
  final Book book;
  const BookScannedPage({super.key, required this.book});

  final String iconArrowUpSVG = "assets/arrow-down.svg";
  final double arrowUpSize = 20;

  @override
  Widget build(BuildContext context) {
    final primeiros3autores = book.authors.sublist(0, (book.authors.length > 2) ? 3 : book.authors.length);
    /*  */
    print(book.imageLinks["thumbnail"]);

    final autoresMapped =
      primeiros3autores.map(
        (autor) => Text(autor,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: (primeiros3autores.length > 1) ? 18 : 22)
                        )
                      )
        ).toList();
      /*  */

    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails details) {
        if(details.primaryVelocity! > 2000) Navigator.pop(context);
      },
      child: Scaffold(
        // =========================
        // =========================
        // APPBAR
        // =========================
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children:<Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      iconArrowUpSVG,
                      width: arrowUpSize,
                      height: arrowUpSize,
                      semanticsLabel: 'Arrow Up Icon'
                    ),
                    Text(
                      "Go back",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(color: Color(0xFF560FA9), fontWeight: FontWeight.w600, fontSize: 22)
                        )
                    )
                  ],
                )
              )
            ]
          )
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                // =========================
                // =========================
                // CAPA NOME AUTOR
                // =========================
                Column(
                  children: [
                    Image.network(
                       book.imageLinks["thumbnail"] != null
                       ? book.imageLinks["thumbnail"].toString()
                       : "https://www.labfriend.co.in/static/assets/images/shared/default-image.png",
                      width: 170,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      child: Text(
                        book.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(color: Color(0xFF560FA9), fontWeight: FontWeight.w600, fontSize: 30)
                        )
                      ),
                    ),
                    Column(children: autoresMapped),
                    Container(
                      margin: const EdgeInsets.only(top: 24),
                      child: Text(
                        book.description,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 20)
                      )),
                    ),
                  ]
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  // make alert dialog height smaller
                  insetPadding: const EdgeInsets.fromLTRB(24, 250, 24, 300),
                  title: const Text('Choose a shelf'),
                  content: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('Want to read'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to Want to read shelf'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Reading'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to Reading shelf'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Read'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to Read shelf'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          backgroundColor: const Color(0xFF560FA9),
          child: const Icon(
              Icons.add, color:
              Color.fromARGB(255, 255, 255, 255)
          ),
        )
      )
    );
  }
}
