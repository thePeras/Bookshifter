import 'package:app/models/book.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class BookScannedPage extends StatelessWidget {
  final Book book;
  const BookScannedPage({super.key, required this.book});

  final String iconArrowUpSVG = "assets/arrow-up.svg";
  final double arrowUpSize = 20;
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (DragEndDetails details) {
        if(details.primaryVelocity! > 2000) Navigator.pushReplacementNamed(context, '/scanner');
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
                    ),
                  ],
                )
              )
            ]
          )
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: <Widget>[
                Text(
                  book.title
                ),
                Image.network(
                  book.imageLinks["thumbnail"].toString(),
                  width: 170,
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
