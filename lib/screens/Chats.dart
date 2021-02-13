import 'package:LangChat/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ChatScreen.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  bool loading = true;
  DocumentSnapshot userDetails;
  Stream chatRooms;

  void fetchData() async {
    userDetails =
        await Database().getUserDetails(FirebaseAuth.instance.currentUser.uid);
    chatRooms = Database().getChatRooms(userDetails['uid']);
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  getChatRoomId(String u1, String u2) {
    if (u1.substring(0, 1).codeUnitAt(0) > u2.substring(0, 1).codeUnitAt(0)) {
      return "$u1\_$u2";
    } else {
      return "$u2\_$u1";
    }
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
            stream: chatRooms,
            builder: (context, snapshot) {
              return (snapshot.hasData)
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        String name = userDetails['name'] == ds['users'][0]
                            ? ds['users'][1]
                            : ds['users'][0];
                        String uid = userDetails['uid'] == ds['userIds'][0]
                            ? ds['userIds'][1]
                            : ds['userIds'][0];
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: EdgeInsets.all(6),
                          child: ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Text(getInitials(name),
                                      style: GoogleFonts.roboto(
                                        fontSize: 15,
                                      ))),
                              title: Text(name),
                              subtitle: Text(userDetails['uid'] == ds['sentBy']
                                  ? ds['lastMsgOrig'].substring(0, 7) + '...'
                                  : ds['lastMsgTrans'].substring(0, 7) + '...'),
                              trailing: Icon(
                                Icons.check,
                                color: Color.fromRGBO(0, 20, 200, 0.4),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen({
                                              'uid': userDetails['uid'],
                                              'prefLang':
                                                  userDetails['prefLang'],
                                              'receiverUid': uid
                                            })));
                              }),
                        );
                      })
                  : Center(
                      child: Center(
                        child: Text('You have not chatted with anyone yet'),
                      ),
                    );
            },
          )
        : Center(child: CircularProgressIndicator());
  }
}
