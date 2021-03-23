import 'dart:async';
import 'package:LangChat/screens/StartApp.dart';
import 'package:LangChat/screens/WelcomeScreen.dart';
import 'package:LangChat/screens/LoginPage.dart';
import 'package:LangChat/backend/authentication.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showStartScreen = true;

  changeScreen() async {
    await Future.delayed(Duration(seconds: 5));
    showStartScreen = false;
    setState(() {});
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: !showStartScreen
          ? FutureBuilder(
              future: Auth().getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return WelcomeScreen();
                } else {
                  return LoginPage();
                }
              })
          : Start(),
      theme: new ThemeData(primarySwatch: Colors.grey),
    );
  }
}
