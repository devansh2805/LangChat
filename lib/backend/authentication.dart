import 'package:LangChat/screens/SettingsPage.dart';
import 'package:LangChat/screens/WelcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'database.dart';

class Auth {
  Future<void> loginUser(String phoneNumber, BuildContext context) async {
    final TextEditingController _codeController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          User user = userCredential.user;
          print(user);
          if (user.phoneNumber != null) {
            var check =
                await Database().userAlreadyRegistered(user.phoneNumber);
            print(check);
            if (check == true) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()));
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            }
          } else {
            print("Error");
          }
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Enter Code"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        final code = _codeController.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId, smsCode: code);
                        UserCredential userCredential =
                            await _auth.signInWithCredential(credential);
                        User user = userCredential.user;
                        print(user);
                        if (user.phoneNumber != null) {
                          var check = await Database()
                              .userAlreadyRegistered(user.phoneNumber);
                          print(check);
                          if (check == true) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WelcomeScreen()));
                          } else {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsPage()));
                          }
                        } else {
                          print("Error");
                        }
                      },
                      child: Text(
                        "Confirm",
                        style: GoogleFonts.sourceSansPro(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.indigo[400]),
                      ),
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }
}
