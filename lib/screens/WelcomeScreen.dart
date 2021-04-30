import 'package:LangChat/backend/authentication.dart';
import 'package:LangChat/screens/UpdateProfile.dart';
import 'package:LangChat/screens/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'Chats.dart' as chats;
import 'Contacts.dart' as contacts;

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  Future<void> _handleTabSelection() async {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 2:
          if (!await Permission.contacts.isGranted) {
            Permission.contacts.request();
          }
      }
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure you want to logout!'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.indigo[400],
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.indigo[50],
          appBar: AppBar(
            title: Text(
              'LangChat',
              style: GoogleFonts.sourceSansPro(
                  fontWeight: FontWeight.bold, fontSize: 22),
            ),
            actions: [
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  _showMyDialog();
                },
              ),
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UpdateProfile()));
                },
              )
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text('Chats',
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
            controller: _tabController,
            children: [
              chats.Chats(),
              contacts.Contacts(),
            ],
          ),
        ),
      ),
    );
  }
}
