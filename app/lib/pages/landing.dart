import 'package:app/api/Api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage();

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  
  final String logoAppSVG = "assets/logo-app.svg";
  final String nome = "Roberto";

  final livros = [
    "assets/A_Ilha_do_Tesouro.jpg",
    "assets/A_Malnascida.jpg",
    "assets/A_Ilha_do_Tesouro.jpg",
    "assets/A_Ilha_do_Tesouro.jpg",
    "assets/A_Ilha_do_Tesouro.jpg",
    "assets/A_Ilha_do_Tesouro.jpg",
    "assets/A_Ilha_do_Tesouro.jpg"
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: SvgPicture.asset(
                      logoAppSVG,
                      width: 50,
                      height: 50,
                      semanticsLabel: 'Bookshifter logo'
                    )
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Welcome back $nome!",
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(color: Color(0xFF560FA9), fontWeight: FontWeight.w600, fontSize: 22)
                        )
                      )
                  ),
                ],
              )
            )
          ]
        )
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => { Navigator.pushNamed(context, '/scanner') },
              child: const Image(image: AssetImage("assets/scanner.jpg"))
            ),
            // =========================
            // =========================
            // LISTA LIVROS
            // =========================
            Container(
              child: Column(
                children:<Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      "Recently Scanned",
                      style: GoogleFonts.montserrat(
                        textStyle: const TextStyle(color: Color(0xFF560FA9), fontWeight: FontWeight.w600, fontSize: 22)
                      )
                    )
                  ),
                  Container(
                    height: 150,
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 60),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(livros.length, (int index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 24),
                            child: Image(image: AssetImage(livros[index]))
                          );
                        }
                      )
                    )
                  )
                ]
              )
            )
            // =========================
            // =========================
            // LISTA LIVROS
            // =========================
          ],
        ),
      ),
    );
  }
}
