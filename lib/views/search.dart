import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversationScreen.dart';
import 'package:chat_app/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;

  // -------------------------------------------------------------- //
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot<Map<String, dynamic>>? searchSnapshot;

  initiateSearch() {
    try {
      setState(() {
        isLoading = true;
      });
      databaseMethods
          .getUserByUserName(searchEditingController.text)
          .then((value) {
        setState(() {
          isLoading = false;
          searchSnapshot = value;
        });
      });
    } catch (ex) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget searchList() {
    if (isLoading)
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: CircularProgressIndicator(
          color: Colors.blue,
        )),
      );
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot?.docs.length ?? 0,
            // when use "ListView" inside a "Column" then use "shrinkWrap"
            // to avoid error "vertical viewport was given unbounded height"
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return userTile(
                userName: searchSnapshot!.docs[index].data()['name'],
                userEmail: searchSnapshot!.docs[index].data()['email'],
              );
            })
        : Container();
  }

  //TODO Create Chat Room, Send user to conversation screen
  createChatRoomAndStartConversation(String userName) {
    if (userName != Constants.myName) {
      List<String> users = [Constants.myName, userName];
      String chatRoomId = getChatRoomId(Constants.myName, userName);
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(
                    chatRoomId: chatRoomId,
                  )));
    } else {
      print('You can not send message to yourself.');
    }
  }

  Widget userTile({required String userName, required String userEmail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: simpleTextStyle(color: Colors.black)),
              Text(userEmail, style: simpleTextStyle(color: Colors.grey)),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50.0)),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Text('Message', style: simpleTextStyle()),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  // -------------------------------------------------------------- //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0xFF32A2FF),
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchEditingController,
                      style: simpleTextStyle(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Username...',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                const Color(0x36FFFFFF),
                                const Color(0x0FFFFFFF)
                              ],
                              begin: FractionalOffset.topLeft,
                              end: FractionalOffset.bottomRight),
                          borderRadius: BorderRadius.circular(40)),
                      child: Image.asset(
                        "images/search_white.png",
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //TODO Show Search List
            searchList()
          ],
        ),
      ),
    );
  }
}
