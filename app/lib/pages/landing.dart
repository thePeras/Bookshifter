import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  
  final String logoAppSVG = "assets/logo-app.svg";
  final String nome = "Roberto";

  final livros = [
    "assets/A_Ilha_do_Tesouro.jpg",
    "assets/A_Malnascida.jpg",
    "assets/A_Viagem_do_Elefante.jpg",
    "assets/Batalha_Incerta.jpg",
    "assets/Esteiros.jpg",
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFFFA500),
      // =========================
      // =========================
      // APPBAR
      // =========================
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          padding: const EdgeInsets.only(bottom: 24),
          decoration: const BoxDecoration(
            color: Color(0xFF560FA9),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36.0),
              bottomRight: Radius.circular(36.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children:<Widget>[
              Text(
                  "Welcome back, $nome!",
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 24)
                  )
                ),
            ]
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            Container(
              margin: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/scanner'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(36.0),
                  child: const Image(image: AssetImage("assets/scanner.jpg"))
                )
              ),
            ),

            // =========================
            // =========================
            // LISTAS LIVROS
            // =========================
            Container(
                padding: const EdgeInsets.only(top: 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36.0),
                    topRight: Radius.circular(36.0),
                  ),
                ),
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
                      margin: const EdgeInsets.fromLTRB(24, 0, 24, 60),
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        "Sugestions",
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(color: Color(0xFF560FA9), fontWeight: FontWeight.w600, fontSize: 22)
                        )
                      )
                    ),
                    Container(
                      height: 150,
                      margin: const EdgeInsets.fromLTRB(24, 0, 24, 60),
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
                ),
              )
          ],
        ),
      )
    );
  }
}
