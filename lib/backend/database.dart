import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future<DocumentReference> sendMessage(String origMessage, String transMessage,
      DateTime timestamp, String senderUid, String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .add({
      'origMessage': origMessage,
      'transMessage': transMessage,
      'timestamp': timestamp,
      'senderUid': senderUid,
    });
  }

  Future<DocumentSnapshot> getUserDetails(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<void> storeUserDetails(
      String uid, String name, String phoneNum, String langPref) async {
    return FirebaseFirestore.instance.collection('users').doc(uid).set(
        {'uid': uid, 'name': name, 'phoneNum': phoneNum, 'langPref': langPref});
  }

  Stream<QuerySnapshot> fetchUsers(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: uid)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> fetchChatsFromDatabase(
      String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('timestamp')
        .snapshots();
  }
}
