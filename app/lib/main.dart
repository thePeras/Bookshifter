import 'dart:convert';
import 'package:app/pages/landing.dart';
import 'package:app/pages/login.dart';
import 'package:app/pages/scanner.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/books/v1.dart' as books;
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  _cameras = await availableCameras();

  runApp(MyApp(camera: _cameras.first));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookShifter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        '/landing': (context) => LandingPage(),
        '/scanner': (context) => ScannerPage(camera: camera),
      },
    );
  }
}
