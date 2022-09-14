import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/core/chat/conversationScreen.dart';
import 'package:chat_app/views/core/chat/search.dart';
import 'package:chat_app/views/signin.dart';
import 'package:chat_app/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  // -------------------------------------------------------------- //
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream<QuerySnapshot<Map<String, dynamic>>>? chatRoomStream;

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                      height: 8,
                    ),
                itemCount: snapshot.data?.docs.length ?? 0,
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    top: 16.0, left: 16.0, bottom: 100, right: 16.0),
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data!.docs[index]
                        .data()['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data!.docs[index].data()["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserNameSharedPreference()) ??
        'مستخدم غير معروف';
    databaseMethods.getChatRoom(Constants.myName).then((snapshots) {
      setState(() {
        chatRoomStream = snapshots;
        print(
            "we got the data + ${chatRoomStream.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  // -------------------------------------------------------------- //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('الدردشة'),
        actions: [
          // GestureDetector(
          //   onTap: () async {
          //     await HelperFunctions.saveUserLoggedInSharedPreference(false);
          //     await authMethods.signOut();
          //     Navigator.pushReplacement(
          //         context, MaterialPageRoute(builder: (context) => SignIn()));
          //   },
          //   child: Container(
          //     padding: EdgeInsets.symmetric(horizontal: 16.0),
          //     child: Icon(Icons.exit_to_app),
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
      body: chatRoomStream != null
          ? chatRoomsList()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({required this.userName, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: Text('${userName.substring(0, 1).toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: chatRoomTileStyle(Colors.white)),
            ),
            SizedBox(width: 12),
            Text(userName,
                textAlign: TextAlign.start,
                style: chatRoomTileStyle(Colors.black)
                    .copyWith(fontSize: 16.0, fontWeight: FontWeight.w600)),
            Spacer(),
            Icon(
              Icons.send_rounded,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
