import 'dart:async';
import 'package:LangChat/screens/HomeScreen.dart';
import 'package:LangChat/screens/LoginPage.dart';
import 'package:LangChat/backend/authentication.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: Auth().getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return LoginPage();
            }
          }),
      theme: new ThemeData(primarySwatch: Colors.grey),
    );
  }
}
