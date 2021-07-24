// login, logout backend
import 'package:LangChat/screens/SettingsPage.dart';
import 'package:LangChat/screens/WelcomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'database.dart';

class Auth {
  Future<void> loginUser(String phoneNumber, BuildContext context) async {
    final TextEditingController _codeController = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: null,
        // (AuthCredential credential) async {
        //   Navigator.of(context).pop();
        //   UserCredential userCredential =
        //       await _auth.signInWithCredential(credential);
        //   User user = userCredential.user;
        //   print(user);
        //   if (user.phoneNumber != null) {
        //     var check =
        //         await Database().userAlreadyRegistered(user.phoneNumber);
        //     print(check);
        //     if (check == true) {
        //       Navigator.pushReplacement(context,
        //           MaterialPageRoute(builder: (context) => WelcomeScreen()));
        //     } else {
        //       Navigator.pushReplacement(context,
        //           MaterialPageRoute(builder: (context) => SettingsPage()));
        //     }
        //   } else {
        //     print("Error");
        //   }
        // },
        verificationFailed: (FirebaseAuthException authException) {
          _showAlertDialog(context, authException.code);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                String errorText = "";
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context).enterCode),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          controller: _codeController,
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) {
                            setState(() => errorText = "");
                          },
                        ),
                        errorText == ""
                            ? SizedBox()
                            : Text(
                                errorText,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          final code = _codeController.text.trim();
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);
                          await _auth
                              .signInWithCredential(credential)
                              .catchError((error) {
                            if (error.code == "session-expired") {
                              Navigator.pop(context);
                              _showAlertDialog(context,
                                  AppLocalizations.of(context).sessionExp);
                            } else {
                              setState(() => errorText = error.code);
                            }
                          }).then((userCredential) async {
                            User user = userCredential.user;

                            bool check = await Database()
                                .userAlreadyRegistered(user.phoneNumber);
                            print(check);
                            if (check == true) {
                              print("user exists");
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WelcomeScreen()),
                                  (route) => false);
                            } else {
                              print("user exists not");
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingsPage()),
                                  (route) => false);
                            }
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context).confirm,
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
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<void> _showAlertDialog(context, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).error,
            style: GoogleFonts.sourceSansPro(),
          ),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }
}
