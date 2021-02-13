import 'package:LangChat/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator/translator.dart';

class ChatScreen extends StatefulWidget {
  Map userDetails;
  ChatScreen(this.userDetails);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId;
  Stream chats;
  DocumentSnapshot receiverDetails;
  final TextEditingController _msgController = TextEditingController();
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
    chatRoomId = getChatRoomId(
        widget.userDetails['uid'], widget.userDetails['receiverUid']);
    receiverDetails =
        await Database().getUserDetails(widget.userDetails['receiverUid']);
    chats = await Database().fetchMessagesFromDatabase(chatRoomId);
  }

  @override
  void initState() {
    fetchData();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffd4daef),
        appBar: AppBar(
          leading: Container(
            margin: EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              maxRadius: 2.0,
              child: Text(getInitials(receiverDetails['name'])),
            ),
          ),
          title: Text(
            receiverDetails['name'],
            style: GoogleFonts.roboto(
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
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                padding: EdgeInsets.all(5),
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                    ds['senderUid'] == widget.userDetails['uid']
                                        ? ds['origMessage']
                                        : ds['transMessage'],
                                    style: GoogleFonts.roboto(
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
                                              ? Radius.circular(10)
                                              : Radius.circular(0),
                                          bottomRight: ds['senderUid'] ==
                                                  widget.userDetails['uid']
                                              ? Radius.circular(0)
                                              : Radius.circular(10))),
                                  padding: EdgeInsets.all(5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    ds['senderUid'] == widget.userDetails['uid']
                                        ? ds['transMessage']
                                        : ds['origMessage'],
                                    style: GoogleFonts.roboto(
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
                borderRadius: BorderRadius.circular(50), color: Colors.white),
            child: Row(children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  controller: _msgController,
                  decoration: InputDecoration(
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
                            to: receiverDetails['prefLang'])
                        .then((msg) async {
                      await Database().sendMessage(
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
        ]));
  }
}
