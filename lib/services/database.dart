import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<QuerySnapshot<Map<String, dynamic>>> getUserByUserName(
      String username) {
    return FirebaseFirestore.instance
        .collection('chatUsers')
        .where('name', isEqualTo: username)
        .get()
        .catchError((e) => print(e.toString()));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByUserEmail(
      String userEmail) {
    return FirebaseFirestore.instance
        .collection('chatUsers')
        .where('email', isEqualTo: userEmail)
        .get()
        .catchError((e) => print(e.toString()));
  }

  uploadUserInfo(userMap) async {
    await FirebaseFirestore.instance
        .collection('chatUsers')
        .add(userMap)
        .catchError((e) => print(e.toString()));
  }

  Future<void> createChatRoom(String chatRoomId, chatRoomMap) async {
    await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) => print(e.toString()));
  }

  Future<void> addConversationMessage(String chatRoomId, messageMap) async {
    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getConversationMessage(
      String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> getChatRoom(
      String itIsMyName) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }
}
