import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future<Stream<QuerySnapshot>> fetchChatsFromDatabase(
      String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .snapshots();
  }
}
