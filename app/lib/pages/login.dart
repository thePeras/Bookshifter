import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/books/v1.dart' as books;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String logoAppSVG = "assets/logo-app.svg";
  final double logoSize = 230;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF560FA9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                SvgPicture.asset(
                  logoAppSVG,
                  width: logoSize,
                  height: logoSize,
                  semanticsLabel: 'Bookshifter logo'
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 60),
                  child: Text(
                    'Welcome to\nBookShifter',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)
                    )
                  )
                )
              ]
            ),
            SignInButton(
              Buttons.google,
              text: "Entrar com a conta Google",
              onPressed: () => Navigator.pushNamed(context, '/landing')
            )
          ],
        ),
      ),
    );
  }
}
