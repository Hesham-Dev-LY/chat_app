import 'package:chat_app/model/post_model.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/core/home/add_post_screen.dart';
import 'package:chat_app/views/signin.dart';
import 'package:chat_app/views/core/home/view_comments.dart';
import 'package:chat_app/widget/full_image.dart';
import 'package:chat_app/widget/post_item.dart';
import 'package:chat_app/widget/view_posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../helper/helperFunctions.dart';
import '../../../widget/widgets.dart';

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
        centerTitle: true,
        title: Text('تطبيق شاتي'),
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
      body: ViewPosts(myPosts: false),
    );
  }
}
