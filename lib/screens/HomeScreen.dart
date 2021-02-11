import 'package:LangChat/backend/authentication.dart';
import 'package:LangChat/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'Calls.dart' as calls;
import 'Chats.dart' as chats;
import 'Contacts.dart' as contacts;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.indigo[400],
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            backgroundColor: Colors.indigo[100],
            appBar: AppBar(
              leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
              title: Text('LangChat'),
              actions: [
                IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () async {
                      await Auth().signOut();
                      Navigator.pop(context);
                    })
              ],
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: Text('Chats'),
                  ),
                  Tab(
                    child: Text('Calls'),
                  ),
                  Tab(
                    child: Text('Contacts'),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                chats.Chats(),
                calls.Calls(),
                contacts.Contacts(),
              ],
            )),
      ),
    );
  }
}
