// this is the screen where you will see all of your contacts who use this app

import 'package:LangChat/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:contacts_service/contacts_service.dart';
import 'ChatScreen.dart';

class Contacts extends StatefulWidget {
  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  bool loading = true;
  DocumentSnapshot userDetails;
  Stream users;
  Iterable<Contact> phoneContacts;
  List phoneNumbers = [];

  void fetchData() async {
    // we fetch all the users who use the app and the list of contacts of current user
    // out of all the users we show only the users who are in the current users contacts
    userDetails =
        await Database().getUserDetails(FirebaseAuth.instance.currentUser.uid);
    users = Database().fetchUsers(userDetails['uid']);
    phoneContacts = await ContactsService.getContacts(
        withThumbnails: false, photoHighResolution: false);
    phoneContacts.forEach((element) {
      element.phones.forEach((number) {
        String trimmedNumber = number.value.replaceAll(" ", "");
        if (trimmedNumber.length > 10) {
          String tenDigitNumber =
              trimmedNumber.substring(trimmedNumber.length - 10);
          phoneNumbers.add(tenDigitNumber);
        } else {
          phoneNumbers.add(trimmedNumber);
        }
      });
    });
    loading = false;
    setState(() {});
  }

  // to check is the user's phone no. is in the contact list
  bool isInPhoneContacts(String userPhoneNumber) {
    bool flag = false;
    phoneNumbers.forEach((element) {
      if (element.toString() ==
          userPhoneNumber.substring(userPhoneNumber.length - 10)) {
        flag = true;
      }
    });
    return flag;
  }

  @override
  void initState() {
    fetchData();
    super.initState();
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

  getChatRoomId(String u1, String u2) {
    if (u1.substring(0, 1).codeUnitAt(0) > u2.substring(0, 1).codeUnitAt(0)) {
      return "$u1\_$u2";
    } else {
      return "$u2\_$u1";
    }
  }

  Widget build(BuildContext context) {
    return !loading
        ? StreamBuilder(
            stream: users,
            builder: (context, snapshot) {
              return (snapshot.hasData)
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data.docs[index];
                        if (isInPhoneContacts(
                            documentSnapshot.data()["phoneNum"])) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.all(6),
                            child: ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    child: Text(
                                        getInitials(
                                            documentSnapshot.data()['name']),
                                        style: GoogleFonts.sourceSansPro(
                                          fontSize: 15,
                                        ))),
                                title: Text(documentSnapshot.data()['name'],
                                    style: GoogleFonts.sourceSansPro(
                                        fontSize: 18)),
                                subtitle: Text(
                                    documentSnapshot.data()['phoneNum'],
                                    style: GoogleFonts.sourceSansPro()),
                                trailing: Icon(
                                  Icons.check,
                                  color: Color.fromRGBO(0, 20, 200, 0.4),
                                ),
                                onTap: () {
                                  var chatRoomId = getChatRoomId(
                                      userDetails.data()['uid'],
                                      documentSnapshot.data()['uid']);
                                  Map<String, dynamic> chatRoomInfo = {
                                    'lastMsgOrig': '',
                                    'lastMsgTrans': '',
                                    'timestamp': '',
                                    'sentBy': '',
                                    'users': [
                                      userDetails.data()['name'],
                                      documentSnapshot.data()['name']
                                    ],
                                    'userIds': [
                                      userDetails.data()['uid'],
                                      documentSnapshot.data()['uid']
                                    ],
                                  };
                                  // this function creates a chatroom only if it doesnt exist
                                  Database()
                                      .createChatRoom(chatRoomId, chatRoomInfo)
                                      .then((s) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatScreen({
                                                  'uid':
                                                      userDetails.data()['uid'],
                                                  'langPref': userDetails
                                                      .data()['langPref'],
                                                  'receiverUid':
                                                      documentSnapshot
                                                          .data()['uid']
                                                })));
                                  });
                                }),
                          );
                        } else {
                          // dont show if not belonging to contacts
                          return SizedBox();
                        }
                      },
                    )
                  : Center(
                      // show loading animation until data is being fetched
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
