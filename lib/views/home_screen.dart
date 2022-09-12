import 'package:chat_app/model/post_model.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/add_post_screen.dart';
import 'package:chat_app/views/chatRoomScreen.dart';
import 'package:chat_app/views/signin.dart';
import 'package:chat_app/widget/full_image.dart';
import 'package:chat_app/widget/post_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/helperFunctions.dart';
import '../widget/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: [
          GestureDetector(
            onTap: () async {
              await HelperFunctions.saveUserLoggedInSharedPreference(false);
              await AuthMethods().signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => SignIn()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.exit_to_app),
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatRoom(),
                    ));
              },
              icon: Icon(
                Icons.chat_bubble,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPostScreen(),
                ));
          },
          child: Icon(Icons.add)),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: DatabaseMethods().getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('فشل الاتصال'),
            );
          }

          List<PostModel> posts = snapshot.data!.docs
              .map((e) => PostModel.fromJson(e.data(), e.id))
              .toList();
          posts.removeWhere((element) =>
              element.userId! == FirebaseAuth.instance.currentUser!.uid);
          return ListView.builder(
              itemCount: posts.length,
              padding: EdgeInsets.only(top: 8.0, bottom: 100),
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                  child: PostItem(model: posts.elementAt(index)),
                );
              });
        },
      ),
    );
  }
}
