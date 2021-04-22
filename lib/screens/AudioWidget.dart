// To Record Audio and Send
import 'package:LangChat/backend/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

// ignore: must_be_immutable
class AudioWidget extends StatefulWidget {
  String receiverLanguage;
  String roomId;

  AudioWidget(String language, String chatRoomID) {
    receiverLanguage = language;
    roomId = chatRoomID;
  }
  @override
  State<StatefulWidget> createState() =>
      _AudioWidgetState(receiverLanguage, roomId);
}

class _AudioWidgetState extends State<AudioWidget> {
  bool _sendCancelVisibility = false;
  bool _audioFilesVisibility = false;
  bool _loadingVisibility = false;
  bool _recordVisibility = true;
  bool _recordAudioVisibility = false;
  bool _isListening = false;
  String _audioString = "Record Audio to send";
  String _listeningString = "";
  String _translatedtext = "";
  String _receiverLanguage = "";
  String _chatRoomId = "";
  SpeechToText _speechToText;
  FlutterTts _flutterTts;
  final GoogleTranslator _googleTranslator = GoogleTranslator();

  _AudioWidgetState(String receiverLanguage, String chatRoomId) {
    _receiverLanguage = receiverLanguage;
    _chatRoomId = chatRoomId;
  }

  @override
  void initState() {
    super.initState();
    _speechToText = SpeechToText();
    _flutterTts = FlutterTts();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.indigo[50],
      child: Container(
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width - 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_audioString),
            Visibility(
              visible: _recordVisibility,
              child: TextButton(
                child: Text("Record"),
                onPressed: _listen,
              ),
            ),
            Visibility(
              visible: _recordAudioVisibility,
              child: AvatarGlow(
                animate: _isListening,
                glowColor: Theme.of(context).primaryColor,
                endRadius: 75.0,
                duration: const Duration(milliseconds: 500),
                repeatPauseDuration: const Duration(milliseconds: 100),
                repeat: true,
                child: Icon(Icons.mic),
              ),
            ),
            Visibility(
              visible: _recordAudioVisibility,
              child: TextButton(
                onPressed: () async {
                  setState(() {
                    _recordAudioVisibility = false;
                    _audioString = "";
                    _isListening = false;
                    _loadingVisibility = true;
                  });
                  _translatedtext = await _translateText();
                  if (_translatedtext == "") {
                    setState(() {
                      _audioString = "Couldnot capture Voice Record Again";
                      _loadingVisibility = false;
                      _recordVisibility = true;
                    });
                  }
                },
                child: Text("Stop Recording"),
              ),
            ),
            Visibility(
              visible: _loadingVisibility,
              child: CircularProgressIndicator(),
            ),
            Visibility(
              visible: _audioFilesVisibility,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Original Audio"),
                  IconButton(
                    onPressed: () {
                      _textToSpeech(_listeningString);
                    },
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _audioFilesVisibility,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Translated Audio"),
                  IconButton(
                    onPressed: () {
                      _textToSpeech(_translatedtext);
                    },
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _sendCancelVisibility,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.green,
                    onPressed: () {
                      Database().sendMessage(
                          _listeningString,
                          _translatedtext,
                          DateTime.now(),
                          FirebaseAuth.instance.currentUser.uid,
                          _chatRoomId,
                          "audio",
                          false);
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel_outlined),
                    color: Colors.red,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (val) => print("onStatus: $val"),
        onError: (val) => print("OnError: $val"),
      );
      if (available) {
        setState(() {
          _audioString = "Recording....";
          _recordVisibility = false;
          _recordAudioVisibility = true;
          _isListening = true;
        });
        _speechToText.listen(onResult: (result) {
          setState(() {
            _listeningString = result.recognizedWords;
          });
        });
      }
    }
  }

  Future<String> _translateText() async {
    setState(() {
      _loadingVisibility = true;
    });
    if (_listeningString != "") {
      Translation message = await _googleTranslator.translate(
        _listeningString,
        to: _receiverLanguage,
      );
      setState(() {
        _loadingVisibility = false;
        _audioFilesVisibility = true;
        _sendCancelVisibility = true;
      });
      return message.toString();
    } else {
      return "";
    }
  }

  void _textToSpeech(String text) async {
    await _flutterTts.speak(text);
  }
}
