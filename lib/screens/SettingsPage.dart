// Settings Page
import 'package:LangChat/backend/database.dart';
import 'package:LangChat/screens/WelcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  String name = '';
  String prefLang = 'English';
  bool validText = false;
  bool textFieldTouched = false;

  Map<String, String> langCodes = {
    'English': 'en',
    'Spanish': 'es',
    'Gujarati': 'gu',
    'German': 'de',
    'Hindi': 'hi',
    'French': 'fr'
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 90.0,
            ),
            Center(
              child: Text(
                AppLocalizations.of(context).enterYourDetails,
                style: GoogleFonts.roboto(
                  color: Colors.grey,
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            TextField(
              controller: _nameController,
              onChanged: (value) {
                textFieldTouched = true;
                if (value == '') {
                  validText = false;
                } else {
                  validText = true;
                }
                setState(() {});
                name = value;
              },
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                ),
                hintText: AppLocalizations.of(context).yourName,
                labelText: AppLocalizations.of(context).enterYourName,
                errorText: (!validText && textFieldTouched)
                    ? AppLocalizations.of(context).valueCantBeEmpty
                    : null,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Text(
              AppLocalizations.of(context).choosePrefLang,
              style: GoogleFonts.roboto(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            DropdownButton<String>(
              value: prefLang,
              icon: Icon(Icons.keyboard_arrow_down),
              iconSize: 24,
              style: GoogleFonts.sourceSansPro(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
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
              ].map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                      child: Text(
                        value,
                        style: GoogleFonts.sourceSansPro(),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
            SizedBox(
              height: 30.0,
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.indigo[400],
                ),
              ),
              onPressed: () async {
                if (_nameController.text == '') {
                  setState(() {
                    validText = false;
                  });
                } else {
                  await Database().storeUserDetails(
                      FirebaseAuth.instance.currentUser.uid,
                      name,
                      FirebaseAuth.instance.currentUser.phoneNumber,
                      langCodes[prefLang]);
                  Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return WelcomeScreen();
                      },
                    ),
                  );
                }
              },
              child: Text(
                AppLocalizations.of(context).next,
                style: GoogleFonts.sourceSansPro(
                    color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
