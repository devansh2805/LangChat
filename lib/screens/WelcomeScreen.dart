import 'package:LangChat/backend/authentication.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Calls.dart' as calls;
import 'Chats.dart' as chats;
import 'Contacts.dart' as contacts;

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
              title: Text('LangChat',
                  style: GoogleFonts.sourceSansPro(
                      fontWeight: FontWeight.bold, fontSize: 22)),
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
                    child: Text('Chats',
                        style: GoogleFonts.sourceSansPro(fontSize: 18)),
                  ),
                  Tab(
                    child: Text('Calls',
                        style: GoogleFonts.sourceSansPro(fontSize: 18)),
                  ),
                  Tab(
                    child: Text('Contacts',
                        style: GoogleFonts.sourceSansPro(fontSize: 18)),
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
