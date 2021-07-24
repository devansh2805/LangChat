import 'dart:async';
import 'package:LangChat/backend/database.dart';
import 'package:LangChat/screens/StartApp.dart';
import 'package:LangChat/screens/WelcomeScreen.dart';
import 'package:LangChat/screens/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings =
      new AndroidInitializationSettings('mipmap/ic_launcher.png');
  InitializationSettings initializationSettings =
      new InitializationSettings(android: androidInitializationSettings);
  AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel(
    'com.example/LangChat',
    'LangChat',
    'Chatting without Language Barries',
    playSound: true,
    enableVibration: true,
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'com.example.LangChat',
    'LangChat',
    'Chatting without Langugae Barriers',
    playSound: true,
    enableVibration: true,
    importance: Importance.max,
    priority: Priority.high,
  );
  NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification.title,
    message.notification.body,
    notificationDetails,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser != null) {
    FirebaseMessaging.instance
        .getToken(
            vapidKey:
                "BLmRST7rURLJElotoqtQYjuuDdTcSprE18YH-aO2mDcCwsgv0DxW-IuGNuud7htfg0Hrc3amvP7jqVuxrT0s_YI")
        .then((token) {
      String uid = FirebaseAuth.instance.currentUser.uid;
      Database().pushToken(uid, token);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool showStartScreen = true;

  changeScreen() async {
    await Future.delayed(Duration(seconds: 5));
    showStartScreen = false;
    setState(() {});
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('hi', ''),
      ],
      debugShowCheckedModeBanner: false,
      home: !showStartScreen
          ? (FirebaseAuth.instance.currentUser == null
              ? LoginPage()
              : WelcomeScreen())
          : Start(),
      theme: new ThemeData(
        primarySwatch: Colors.grey,
      ),
    );
  }
}
