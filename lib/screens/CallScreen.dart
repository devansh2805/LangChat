import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  String receiverName = "John Doe";
  String status = "calling...";
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
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Text(
            // calling..
            status,
            style: GoogleFonts.roboto(fontSize: 30, color: Colors.black),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          CircleAvatar(
            // user avatar
            backgroundImage: AssetImage('assets/dummy.png'),
            radius: 60,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Container(
            // options
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Ink(
                  decoration: const ShapeDecoration(
                    color: Color(0xff7269ef),
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(20),
                    icon: Icon(Icons.volume_up, color: Colors.white),
                    onPressed: () {},
                    color: Color(0xff7269ef),
                  ),
                ),
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.red,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(20),
                    icon: Icon(Icons.call_end, color: Colors.white),
                    color: Colors.red,
                    onPressed: () {},
                  ),
                ),
                Ink(
                  decoration: const ShapeDecoration(
                    color: Color(0xff7269ef),
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.all(20),
                    icon: Icon(Icons.mic_off, color: Colors.white),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
