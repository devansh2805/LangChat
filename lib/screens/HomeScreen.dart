import 'package:LangChat/backend/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'Calls.dart' as calls;
import 'Chats.dart' as chats;
import 'Contacts.dart' as contacts;

class HomeScreen extends StatelessWidget {
  User user;

  HomeScreen(User user) {
    this.user = user;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: new Color(0xff622F74),
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
              title: Text('LangChat'),
              actions: [
                IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.lock_open),
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
                new chats.Chats(),
                new calls.Calls(),
                new contacts.Contacts(),
              ],
            )),
      ),
    );
  }
}
