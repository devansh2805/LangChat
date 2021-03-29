import 'package:LangChat/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator/translator.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  Map<String, dynamic> userDetails;
  ChatScreen(this.userDetails);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool loading = true;
  String chatRoomId;
  Stream chats;
  DocumentSnapshot receiverDetails;
  final TextEditingController _msgController = new TextEditingController();
  final translator = GoogleTranslator();

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

  fetchData() async {
    // we create the chatroom id from the two user's uid and fetch the messages
    chatRoomId = getChatRoomId(
        widget.userDetails['uid'], widget.userDetails['receiverUid']);
    chats = Database().fetchMessagesFromDatabase(chatRoomId);
    receiverDetails =
        await Database().getUserDetails(widget.userDetails['receiverUid']);

    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading == false
        ? Scaffold(
            backgroundColor: Color(0xffd4daef),
            appBar: AppBar(
              leading: Container(
                margin: EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  maxRadius: 2.0,
                  child: Text(getInitials(receiverDetails.data()['name'])),
                ),
              ),
              title: Text(
                receiverDetails.data()['name'],
                style: GoogleFonts.sourceSansPro(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.call,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // call person
                    })
              ],
              backgroundColor: Colors.white,
            ),
            body: ListView(children: [
              Container(
                  // Chat area
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width - 10,
                  child: StreamBuilder(
                    stream: chats,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data.docs[index];
                              return Container(
                                // message area
                                margin: EdgeInsets.all(10),
                                alignment:
                                    ds['senderUid'] == widget.userDetails['uid']
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width - 10,
                                child: Column(children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: ds['senderUid'] ==
                                                widget.userDetails['uid']
                                            ? Colors.indigo[400]
                                            : Color(0xff7269ef),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15))),
                                    padding: EdgeInsets.all(5),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                        ds['senderUid'] ==
                                                widget.userDetails['uid']
                                            ? ds['origMessage']
                                            : ds['transMessage'],
                                        style: GoogleFonts.sourceSansPro(
                                            color: Colors.white, fontSize: 16)),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          color: ds['senderUid'] ==
                                                  widget.userDetails['uid']
                                              ? Colors.indigo[300]
                                              : Color(0xff9b95f5),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: ds['senderUid'] ==
                                                      widget.userDetails['uid']
                                                  ? Radius.circular(15)
                                                  : Radius.circular(0),
                                              bottomRight: ds['senderUid'] ==
                                                      widget.userDetails['uid']
                                                  ? Radius.circular(0)
                                                  : Radius.circular(15))),
                                      padding: EdgeInsets.all(5),
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        ds['senderUid'] ==
                                                widget.userDetails['uid']
                                            ? ds['transMessage']
                                            : ds['origMessage'],
                                        style: GoogleFonts.sourceSansPro(
                                            color: Colors.white, fontSize: 16),
                                      )),
                                ]),
                              );
                            });
                      } else {
                        return Container();
                      }
                    },
                  )),
              Container(
                // typing area
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width - 10,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white),
                child: Row(children: [
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Send some message...",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      if (_msgController.text.isEmpty) {
                      } else {
                        translator
                            .translate(_msgController.text,
                                to: receiverDetails.data()['langPref'])
                            .then((msg) {
                          Database().sendMessage(
                              _msgController.text,
                              msg.toString(),
                              DateTime.now(),
                              widget.userDetails['uid'],
                              chatRoomId);
                          _msgController.text = '';
                          setState(() {});
                        });
                      }
                    },
                  )
                ]),
              ),
            ]))
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
