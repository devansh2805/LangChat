import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
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
        .snapshots();
  }
}
