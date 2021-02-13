import 'package:LangChat/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ChatScreen.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  bool loading = true;
  DocumentSnapshot userDetails;

  void fetchData() async {
    userDetails =
        await Database().getUserDetails(FirebaseAuth.instance.currentUser.uid);
    loading = false;
    setState(() {});
  }

  String getInitials(String name) {
    String intitials = '';
    name.split(' ').forEach((word) {
      if (word.length > 0) {
        intitials += word[0].toUpperCase();
      }
    });
    return intitials;
  }

  Widget build(BuildContext context) {
    return !loading
        ? StreamBuilder(
            stream: Database().fetchUsers(userDetails['uid']),
            builder: (context, snapshot) {
              return (snapshot.hasData)
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: EdgeInsets.all(6),
                          child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Text(getInitials(ds['name']),
                                      style: GoogleFonts.roboto(
                                        fontSize: 15,
                                      ))),
                              title: Text(ds['name']),
                              subtitle: Text('Chat snippet for $index'),
                              trailing: Icon(
                                Icons.check,
                                color: Color.fromRGBO(0, 20, 200, 0.4),
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen({
                                              'uid': userDetails['uid'],
                                              'prefLang':
                                                  userDetails['prefLang']
                                            }, {
                                              'uid': ds['uid'],
                                              'prefLang': ds['prefLang'],
                                              'name': ds['name'],
                                              'initials':
                                                  getInitials(ds['name'])
                                            })));
                              }),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.indigo[400]),
                      ),
                    );
            },
          )
        : Center(child: CircularProgressIndicator());
  }
}
