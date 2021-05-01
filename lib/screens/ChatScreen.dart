// chat screen
import 'package:LangChat/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator/translator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'AudioWidget.dart';
import 'package:intl/intl.dart';

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
  FlutterTts _flutterTts;
  Map<String, String> languageMap = {
    'en': 'en-US',
    'es': 'es-ES',
    'gu': 'gu-IN',
    'de': 'de-DE',
    'hi': 'hi-IN',
    'fr': 'fr-FR',
  };

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
    _flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  TextStyle msgStyle(Color color) {
    return GoogleFonts.quicksand(
        color: color, fontSize: 16, fontWeight: FontWeight.w500);
  }

  void _textToSpeech(String text, String language) async {
    language = languageMap[language];
    await _flutterTts.setLanguage(language);
    await _flutterTts.setSpeechRate(1.0);
    await _flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return loading == false
        ? Scaffold(
            backgroundColor: Color(0xffd4daef),
            appBar: AppBar(
              leading: Container(
                margin: EdgeInsets.all(8),
                child: Hero(
                  tag: "profile",
                  child: CircleAvatar(
                    backgroundImage: receiverDetails.data()["imageUrl"] == ""
                        ? AssetImage(
                            "assets/dummy.png",
                          )
                        : NetworkImage(
                            receiverDetails.data()["imageUrl"],
                          ),
                  ),
                ),
              ),
              title: Text(
                receiverDetails.data()['name'],
                style: GoogleFonts.sourceSansPro(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: ListView(
              children: [
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
                                if (ds.data()['read'] == false) {
                                  Database().seen(
                                      chatRoomId, widget.userDetails['uid']);
                                }
                                bool visible = false;

                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState1) {
                                  return Container(
                                    // message area
                                    margin: EdgeInsets.all(10),
                                    alignment: ds['senderUid'] ==
                                            widget.userDetails['uid']
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    width:
                                        MediaQuery.of(context).size.width - 10,
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onLongPress: () {
                                            setState1(() => visible = !visible);
                                          },
                                          child: Container(
                                            // first container
                                            decoration: BoxDecoration(
                                              color: ds['senderUid'] ==
                                                      widget.userDetails['uid']
                                                  ? Color(0xfff5f5f5)
                                                  : Colors.indigo[400],
                                              // Color(0xff7269ef),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15),
                                              ),
                                            ),
                                            alignment: ds['senderUid'] ==
                                                    widget.userDetails['uid']
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            padding: EdgeInsets.all(5),
                                            width: ds['msgType'] == "text"
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                            child: ds['msgType'] == 'text'
                                                ? Text(
                                                    ds['senderUid'] ==
                                                            widget.userDetails[
                                                                'uid']
                                                        ? ds['origMessage']
                                                        : ds['transMessage'],
                                                    style: msgStyle(ds[
                                                                'senderUid'] ==
                                                            widget.userDetails[
                                                                'uid']
                                                        ? Colors.black
                                                        : Colors.white),
                                                  )
                                                : MaterialButton(
                                                    animationDuration:
                                                        Duration(seconds: 1),
                                                    onPressed: () {
                                                      ds['senderUid'] ==
                                                              widget.userDetails[
                                                                  'uid']
                                                          ? _textToSpeech(
                                                              ds['origMessage'],
                                                              widget.userDetails[
                                                                  'langPref'])
                                                          : _textToSpeech(
                                                              ds[
                                                                  'transMessage'],
                                                              receiverDetails
                                                                      .data()[
                                                                  'langPref']);
                                                    },
                                                    color: Colors.indigo[50],
                                                    textColor: Colors.grey,
                                                    splashColor: Colors.indigo,
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      size: 24,
                                                    ),
                                                    shape: CircleBorder(),
                                                  ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: visible,
                                          child: Container(
                                            // second container
                                            decoration: BoxDecoration(
                                              color: ds['senderUid'] ==
                                                      widget.userDetails['uid']
                                                  ? Colors.white
                                                  : Colors.indigo[300],
                                              // Color(0xff9b95f5),
                                              // borderRadius: BorderRadius.only(
                                              //   bottomLeft: ds['senderUid'] ==
                                              //           widget.userDetails['uid']
                                              //       ? Radius.circular(15)
                                              //       : Radius.circular(0),
                                              //   bottomRight: ds['senderUid'] ==
                                              //           widget.userDetails['uid']
                                              //       ? Radius.circular(0)
                                              //       : Radius.circular(15),
                                              // ),
                                            ),
                                            padding: EdgeInsets.all(5),
                                            width: ds['msgType'] == "text"
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                            alignment: ds['senderUid'] ==
                                                    widget.userDetails['uid']
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: ds['msgType'] == 'text'
                                                ? Text(
                                                    ds['senderUid'] ==
                                                            widget.userDetails[
                                                                'uid']
                                                        ? ds['transMessage']
                                                        : ds['origMessage'],
                                                    style: msgStyle(ds[
                                                                'senderUid'] ==
                                                            widget.userDetails[
                                                                'uid']
                                                        ? Colors.black
                                                        : Colors.white),
                                                  )
                                                : MaterialButton(
                                                    animationDuration:
                                                        Duration(seconds: 1),
                                                    onPressed: () {
                                                      ds['senderUid'] ==
                                                              widget.userDetails[
                                                                  'uid']
                                                          ? _textToSpeech(
                                                              ds[
                                                                  'transMessage'],
                                                              receiverDetails
                                                                      .data()[
                                                                  'langPref'])
                                                          : _textToSpeech(
                                                              ds['origMessage'],
                                                              widget.userDetails[
                                                                  'langPref']);
                                                    },
                                                    color: Colors.indigo[50],
                                                    textColor: Colors.grey,
                                                    splashColor: Colors.indigo,
                                                    child: Icon(
                                                      Icons.play_arrow,
                                                      size: 24,
                                                    ),
                                                    shape: CircleBorder(),
                                                  ),
                                          ),
                                        ),
                                        Container(
                                          // time
                                          decoration: BoxDecoration(
                                            color: ds['senderUid'] ==
                                                    widget.userDetails['uid']
                                                ? visible
                                                    ? Colors.white
                                                    : Color(0xfff5f5f5)
                                                : visible
                                                    ? Colors.indigo[300]
                                                    : Colors.indigo[400],
                                            // Color(0xff9b95f5),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: ds['senderUid'] ==
                                                      widget.userDetails['uid']
                                                  ? Radius.circular(15)
                                                  : Radius.circular(0),
                                              bottomRight: ds['senderUid'] ==
                                                      widget.userDetails['uid']
                                                  ? Radius.circular(0)
                                                  : Radius.circular(15),
                                            ),
                                          ),
                                          width: ds['msgType'] == "text"
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.6
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                          alignment: ds['senderUid'] ==
                                                  widget.userDetails['uid']
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          // color: Colors.white.withOpacity(0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Row(
                                              mainAxisAlignment: ds[
                                                          'senderUid'] ==
                                                      widget.userDetails['uid']
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  DateFormat('dd MMM  HH:mm')
                                                      .format(ds['timestamp']
                                                          .toDate())
                                                      .toString(),
                                                  style: GoogleFonts.openSans(
                                                      color: ds['senderUid'] ==
                                                              widget.userDetails[
                                                                  'uid']
                                                          ? Colors.black
                                                          : Colors.white,
                                                      fontSize: 12),
                                                ),
                                                SizedBox(width: 10),
                                                (ds['senderUid'] ==
                                                            widget.userDetails[
                                                                'uid'] &&
                                                        ds['read'])
                                                    ? Icon(Icons.done_all,
                                                        color: Colors.blue)
                                                    : SizedBox()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
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
                  child: Row(
                    children: [
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
                          Icons.mic,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          if (await Permission.microphone.isGranted) {
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return AudioWidget(
                                      widget.userDetails['langPref'],
                                      receiverDetails.data()['langPref'],
                                      chatRoomId,
                                      languageMap);
                                });
                          } else {
                            Permission.microphone.request();
                          }
                        },
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
                                  chatRoomId,
                                  "text",
                                  false);
                              _msgController.text = '';
                              setState(() {});
                            });
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
