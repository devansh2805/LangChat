// Splash Screen
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 200),
              Image.asset("assets/chatlogo.png"),
              SizedBox(height: 30),
              Text(
                "LangChat",
                style: GoogleFonts.sourceSansPro(
                    color: Colors.indigo[400],
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Removing Language Barrier",
                style: GoogleFonts.sourceSansPro(
                    color: Colors.grey[600], fontSize: 17),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        child: Image.asset("assets/bg.png"),
        bottom: 0,
        right: 0,
      )
    ]);
  }
}
