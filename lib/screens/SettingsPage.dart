import 'dart:html';

import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';

// void main() {
//   runApp(MyApp());
// }

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LangChat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
// File image;
// Future getImage() async {
//   Final image = await ImagePicker.pickImage(ImageSource.gallery);

// }

class Language {
  List<String> getLanguage() {
    var items = List<String>.generate(50, (index) => "Language $index");
    return items;
  }
}

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String value = '';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LangChat",
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            width: 200.0,
            height: 50.0,
          ),
          Icon(
            Icons.account_circle,
            size: 200,
            color: Colors.blue,
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Your name',
              labelText: 'Enter your name here',
            ),
            // onSaved: (String value) {
            //   // This optional block of code can be used to run
            //   // code when the user saves the form.
            // },
            // validator: (String value) {
            //   //return value.contains('@') ? 'Do not use the @ char.' : null;
            // },
          ),
          SizedBox(
            width: 200.0,
            height: 75.0,
          ),
          DropdownButton<String>(
            // <------------------------ Here
            items: [
              DropdownMenuItem<String>(
                value: "Language 1",
                child: Center(
                  child: Text("Language 1"),
                ),
              ),
              DropdownMenuItem<String>(
                value: "Language 2",
                child: Center(
                  child: Text("Language 2"),
                ),
              ),
              DropdownMenuItem<String>(
                value: "Language 3",
                child: Center(
                  child: Text("Language 3"),
                ),
              ),
              DropdownMenuItem<String>(
                value: "Language 4",
                child: Center(
                  child: Text("Language 4"),
                ),
              ),
            ],
            onChanged: (_value) {
              setState(() {
                value = _value;
              });
            },
            hint: Text("Select your preferred language"),
          ),
          Text(
            "$value ",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            width: 200.0,
            height: 100.0,
          ),
          RaisedButton(
            color: Colors.blue,
            onPressed: () {},
            child: Text('Update'),
          ),
          SizedBox(
            width: 200.0,
            height: 50.0,
          ),
        ],
      ),
    );
  }
}
