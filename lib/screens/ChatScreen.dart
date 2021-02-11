import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Message {
  String text;
  String translatedText;
  bool mine;
  Message(this.text, this.translatedText, this.mine);
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // dummy data
  List<Message> messages = [
    Message("Hello", "Hallo", false),
    Message("Good morning", "Guten morgen", true),
    Message("Your app is very nice", "Iher app is sehr nett", false),
    Message("Hello", "Hallo", false),
    Message("Good morning", "Guten morgen", true),
    Message("Your app is very nice. What is your name?",
        "Iher app is sehr nett. Wie ist iher name?", false),
    Message("Hello", "Hallo", false),
    Message("Good morning", "Guten morgen", true),
    Message("Your app is very nice", "Iher app is sehr nett", false)
  ];
  String receiverName = "John Doe";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffd4daef),
        appBar: AppBar(
          title: Text(
            receiverName,
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
            child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Container(
                    // message area
                    margin: EdgeInsets.all(10),
                    alignment: messages[index].mine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width - 10,
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                            color: messages[index].mine
                                ? Colors.indigo[400]
                                : Color(0xff7269ef),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        padding: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(messages[index].text,
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 16)),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: messages[index].mine
                                  ? Colors.indigo[300]
                                  : Color(0xff9b95f5),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          padding: EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width * 0.6,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            messages[index].translatedText,
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 16),
                          )),
                    ]),
                  );
                }),
          ),
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
                onPressed: () {},
              )
            ]),
          ),
        ]));
  }
}
