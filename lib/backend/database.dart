import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  // check whether the phone number is already registered
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

  // send a message
  sendMessage(String origMessage, String transMessage, DateTime timestamp,
      String senderUid, String chatRoomId, String msgType) async {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .add({
      'origMessage': origMessage,
      'transMessage': transMessage,
      'timestamp': timestamp,
      'senderUid': senderUid,
      'msgType': msgType
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomId)
          .update({
        'lastMsgOrig': origMessage,
        'lastMsgTrans': transMessage,
        'timestamp': timestamp,
        'sentBy': senderUid,
        'lastMsgType': msgType
      });
    });
  }

  Future<void> updateProfilePic(String uid, String url) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({"imageUrl": url});
  }

  // to get user details from user id
  Future<DocumentSnapshot> getUserDetails(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  // store user details
  Future<void> storeUserDetails(
      String uid, String name, String phoneNum, String langPref) async {
    return FirebaseFirestore.instance.collection('users').doc(uid).set(
        {'uid': uid, 'name': name, 'phoneNum': phoneNum, 'langPref': langPref});
  }

  // fetch all users to show in the Contacts page
  Stream<QuerySnapshot> fetchUsers(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: uid)
        .snapshots();
  }

  // fetch messages from the chatroom when a user opens chat
  Stream<QuerySnapshot> fetchMessagesFromDatabase(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('timestamp')
        .snapshots();
  }

  // create a chatroom if it does not exist
  Future<void> createChatRoom(String chatRoomId, Map chatRoomDetails) async {
    var chatRoom = await FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomId)
        .get();
    if (chatRoom.exists) {
    } else {
      FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomId)
          .set(chatRoomDetails);
    }
  }

  // to get chatrooms on chats page (people that we have already chatted with)
  Stream<QuerySnapshot> getChatRooms(String uid) {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .where('userIds', arrayContains: uid)
        .snapshots();
  }

  // change the Language
  changeLangPref(String uid, String langPref) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'langPref': langPref});
  }
}
