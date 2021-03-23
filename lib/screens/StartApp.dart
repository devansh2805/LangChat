import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 200),
              Image.asset("assets/a.png"),
              SizedBox(height: 30),
              Text("LangChat",
                  style: GoogleFonts.sourceSansPro(
                      color: Colors.indigo[400],
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Text("Removing Language Barrier",
                  style: GoogleFonts.sourceSansPro(
                      color: Colors.grey[600], fontSize: 17)),
            ],
          ),
        ));
  }
}
