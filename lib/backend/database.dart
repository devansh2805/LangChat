import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  userAlreadyRegistered(String phoneNum) async {
    QuerySnapshot user = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNum', isEqualTo: phoneNum)
        .get();
    if (user.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  sendMessage(String origMessage, String transMessage, DateTime timestamp,
      String senderUid, String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .add({
      'origMessage': origMessage,
      'transMessage': transMessage,
      'timestamp': timestamp,
      'senderUid': senderUid,
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomId)
          .update({
        'lastMsgOrig': origMessage,
        'lastMsgTrans': transMessage,
        'timestamp': timestamp,
        'sentBy': senderUid
      });
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

  Future<Stream<QuerySnapshot>> fetchMessagesFromDatabase(
      String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('timestamp')
        .snapshots();
  }

  checkIfChatRoomExists(String chatRoomId) async {
    var chatRoom = await FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .get();
    if (chatRoom.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> createChatRoom(String chatRoomId, Map chatRoomDetails) async {
    FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .set(chatRoomDetails);
  }

  Stream<QuerySnapshot> getChatRooms(String uid) {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .where('userIds', arrayContains: uid)
        .orderBy('timestamp')
        .snapshots();
  }
}
