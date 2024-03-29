// this is the screen where you will see the people with whom you have already chatted
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    chatRooms = Database().getChatRooms(userDetails.data()['uid']);
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  getChatRoomId(String u1, String u2) {
    // we compare the first letter of both the uid
    // this is to get the same chatroom id every time from two uids
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.indigo[500]),
                  ),
                );
              } else {
                return (snapshot.hasData && snapshot.data.docs.length > 0)
                    ? ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          if (ds.data()['lastMsgOrig'] == '') {
                            // we dont want to show the chatroom if there are no chats
                            return SizedBox();
                          } else {
                            String name = userDetails.data()['name'] ==
                                    ds.data()['users'][0]
                                ? ds.data()['users'][1]
                                : ds.data()['users'][0];
                            String uid = userDetails.data()['uid'] ==
                                    ds.data()['userIds'][0]
                                ? ds.data()['userIds'][1]
                                : ds.data()['userIds'][0];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              margin: EdgeInsets.all(6),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 25,
                                  child: Text(
                                    getInitials(name),
                                    style: GoogleFonts.sourceSansPro(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  name,
                                  style: GoogleFonts.sourceSansPro(
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle: Text(
                                  // if the last message was sent by user show the original msg
                                  // else show translated msg
                                  // we show only few snippets of the msg
                                  ds.data()['lastMsgType'] == "audio"
                                      ? "Audio 🔈"
                                      : userDetails.data()['uid'] ==
                                              ds.data()['sentBy']
                                          ? (ds.data()['lastMsgOrig'].length >
                                                  15
                                              ? ds
                                                      .data()['lastMsgOrig']
                                                      .substring(0, 15) +
                                                  '...'
                                              : ds.data()['lastMsgOrig'])
                                          : (ds.data()['lastMsgTrans'].length >
                                                  15
                                              ? ds
                                                      .data()['lastMsgTrans']
                                                      .substring(0, 15) +
                                                  '...'
                                              : ds.data()['lastMsgTrans']),
                                  style: GoogleFonts.quicksand(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: (ds.data()['lastMsgSeen'] == false &&
                                            ds.data()['senderUid'] !=
                                                userDetails.data()['uid'])
                                        ? Colors.indigo
                                        : Colors.grey,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        {
                                          'uid': userDetails.data()['uid'],
                                          'langPref':
                                              userDetails.data()['langPref'],
                                          'receiverUid': uid
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/no_res.png',
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              AppLocalizations.of(context).noChats,
                              style: GoogleFonts.quicksand(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
              }
            },
          )
        : Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo[500]),
            ),
          );
  }
}
