// to change language preference

import 'package:LangChat/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  bool loading = true;
  String uid;
  DocumentSnapshot userDetails;
  String prefLang;
  String profilePicUrl;
  Map<String, String> langCodes = {
    'English': 'en',
    'Spanish': 'es',
    'Gujarati': 'gu',
    'German': 'de',
    'Hindi': 'hi',
    'French': 'fr'
  };

  fetchData() async {
    uid = FirebaseAuth.instance.currentUser.uid;
    userDetails = await Database().getUserDetails(uid);
    profilePicUrl = userDetails.data()['imageUrl'];
    prefLang = userDetails.data()['langPref'];
    prefLang = langCodes.keys
        .firstWhere((k) => langCodes[k] == prefLang, orElse: () => null);
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
      ),
      body: !loading
          ? Center(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: profilePicUrl == ""
                            ? AssetImage("assets/dummy.png")
                            : NetworkImage(profilePicUrl),
                        radius: width * 0.2,
                      ),
                      Positioned(
                        child: MaterialButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) =>
                                  bottomSheet(context, profilePicUrl)),
                            );
                          },
                          color: Colors.indigo[400],
                          textColor: Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                            size: 24,
                          ),
                          shape: CircleBorder(),
                        ),
                        top: width * 0.25,
                        left: width * 0.25,
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    userDetails.data()['name'],
                    style: GoogleFonts.sourceSansPro(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 45),
                  Text(
                    AppLocalizations.of(context).choosePrefLang,
                    style: GoogleFonts.sourceSansPro(
                      color: Colors.grey[600],
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: prefLang,
                    icon: Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    style: GoogleFonts.sourceSansPro(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        prefLang = newValue;
                      });
                    },
                    items: <String>[
                      'English',
                      'French',
                      'Gujarati',
                      'German',
                      'Hindi',
                      'Spanish'
                    ].map(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            child: Text(
                              value,
                              style: GoogleFonts.sourceSansPro(),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  SizedBox(height: 50),
                  TextButton(
                    onPressed: () async {
                      await Database().changeLangPref(uid, langCodes[prefLang]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              AppLocalizations.of(context).langPrefUpdated),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.indigo[400]),
                    ),
                    child: Text(
                      AppLocalizations.of(context).save,
                      style: GoogleFonts.sourceSansPro(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile photo;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      try {
        photo = await _picker.getImage(source: ImageSource.gallery);
        var file = File(photo.path);
        if (photo != null) {
          final Reference firebaseStorageRef =
              _storage.ref().child("users/$uid");
          final TaskSnapshot taskSnapshot =
              await firebaseStorageRef.putFile(file);
          String url = await taskSnapshot.ref.getDownloadURL();
          await Database().updateProfilePic(uid, url);
          setState(() {
            profilePicUrl = url;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).somethingWentWrong),
          ),
        );
      }
    } else {
      print("Permission was not granted");
    }
  }

  Widget bottomSheet(BuildContext context, String imageUrl) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: imageUrl == null
                  ? null
                  : () async {
                      await Database().updateProfilePic(uid, "");
                      setState(() {
                        profilePicUrl = "";
                      });
                      Navigator.pop(context);
                    },
              child: Text(
                AppLocalizations.of(context).removeProfile,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: imageUrl == "" || imageUrl == null
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: () async {
                await uploadImage();
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.camera,
                color: Colors.black,
              ),
              label: Text(
                AppLocalizations.of(context).chooseImg,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
