import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasvir/widgets/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //hide debug banner

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tasvir',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}
