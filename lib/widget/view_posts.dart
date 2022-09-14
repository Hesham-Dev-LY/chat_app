import 'package:chat_app/widget/post_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/post_model.dart';
import '../services/database.dart';
import '../views/core/home/view_comments.dart';

class ViewPosts extends StatefulWidget {
  const ViewPosts({this.myPosts = false, Key? key}) : super(key: key);
  final bool myPosts;

  @override
  State<ViewPosts> createState() => _ViewPostsState();
}

class _ViewPostsState extends State<ViewPosts> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: DatabaseMethods().getPosts(widget.myPosts),
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
        if (!widget.myPosts)
          posts.removeWhere((element) =>
              element.userId! == FirebaseAuth.instance.currentUser!.uid);

        if (posts.isEmpty) {
          return Center(
            child: Text('لاتوجد منشورات'),
          );
        }
        return ListView.builder(
            itemCount: posts.length,
            padding: EdgeInsets.only(top: 8.0, bottom: 100),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: PostItem(
                    model: posts.elementAt(index),
                    owner: widget.myPosts,
                    onPostDeleted: () {
                      setState(() {});
                    },
                    onCommentClick: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewComments(
                              postId: posts.elementAt(index).postId!,
                            ),
                          )).then((value) {
                        if (mounted) setState(() {});
                      });
                    }),
              );
            });
      },
    );
  }
}
