// to change language preference

import 'package:LangChat/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeLang extends StatefulWidget {
  @override
  _ChangeLangState createState() => _ChangeLangState();
}

class _ChangeLangState extends State<ChangeLang> {
  bool loading = true;
  String uid;
  DocumentSnapshot userDetails;
  String prefLang;
  Map<String, String> langCodes = {
    'English': 'en',
    'Spanish': 'es',
    'Gujarati': 'gu',
    'German': 'de',
    'Hindi': 'hi',
    'French': 'fr'
  };

  fetchData() async {
    uid = FirebaseAuth.instance.currentUser.uid;
    userDetails = await Database().getUserDetails(uid);
    prefLang = userDetails.data()['langPref'];
    prefLang = langCodes.keys
        .firstWhere((k) => langCodes[k] == prefLang, orElse: () => null);
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
      ),
      body: !loading
          ? Center(
              child: Column(children: [
                SizedBox(height: 70),
                Image.asset("assets/a.png"),
                SizedBox(height: 90),
                Text("Change your preferred language",
                    style: GoogleFonts.sourceSansPro(
                        color: Colors.black, fontSize: 22)),
                SizedBox(height: 20),
                DropdownButton<String>(
                  value: prefLang,
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 24,
                  style: GoogleFonts.sourceSansPro(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      prefLang = newValue;
                    });
                  },
                  items: <String>[
                    'English',
                    'French',
                    'Gujarati',
                    'German',
                    'Hindi',
                    'Spanish'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          child: Text(
                            value,
                            style: GoogleFonts.sourceSansPro(),
                          ),
                        ));
                  }).toList(),
                ),
                SizedBox(height: 50),
                TextButton(
                  onPressed: () async {
                    await Database().changeLangPref(uid, langCodes[prefLang]);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Language preference updated"),
                    ));
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.indigo[400]),
                  ),
                  child: Text(
                    "SAVE",
                    style: GoogleFonts.sourceSansPro(
                        color: Colors.white, fontSize: 20),
                  ),
                )
              ]),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
