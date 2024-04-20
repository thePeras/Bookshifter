import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';


class BookScannedPage extends StatefulWidget {
  final AuthClient client;
  const BookScannedPage({super.key, required this.client});

  @override
  State<BookScannedPage> createState() => _BookScannedState();
}



class _BookScannedState extends State<BookScannedPage> {
  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Column(
        children: [
          Text("aaa")
        ],
      )
    );
  }
}
