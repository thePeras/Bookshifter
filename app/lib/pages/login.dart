import 'package:flutter/material.dart';
import 'package:googleapis/books/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String logoAppSVG = "assets/logo-app.svg";
  final double logoSize = 230;



  final _googleSignIn = GoogleSignIn(
    scopes: <String>[BooksApi.booksScope],
  );


  Future<void> _handleSignIn() async{
    try{
      await _googleSignIn.signIn();

      
      /* final googleAuth = googleAccount?.authentication;

      var httpClient = (await _googleSignIn.authenticatedClient())!; */
    }
    catch(error){
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF560FA9),
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
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30)
                    )
                  )
                )
              ]
            ),
            SignInButton(
              Buttons.google,
              text: "Entrar com a conta Google",
              onPressed: _handleSignIn,
            )
          ],
        ),
      ),
    );
  }
}
