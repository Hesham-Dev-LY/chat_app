import 'package:chat_app/model/comment_model.dart';
import 'package:chat_app/widget/text_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewComments extends StatefulWidget {
  const ViewComments({Key? key, required this.postId}) : super(key: key);
  final String postId;

  @override
  State<ViewComments> createState() => _ViewCommentsState();
}

class _ViewCommentsState extends State<ViewComments> {
  late Future<QuerySnapshot<Map<String, dynamic>>> getComments;

  @override
  void initState() {
    // TODO: implement initState
    getComments = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .orderBy('date')
        .get();
    super.initState();
  }

  TextEditingController comment = TextEditingController();
  List<CommentModel> comments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: getComments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Text('ERROR');
              }
              if (comments.isEmpty)
                comments = snapshot.data!.docs
                    .map((e) => CommentModel.fromJson(e.data()))
                    .toList();
              if (comments.isEmpty) {
                return Center(
                  child: Text('NO COMMENTS'),
                );
              }

              return ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                        title: Text(
                          comments.elementAt(index).userName ?? 'Unknown',
                        ),
                        subtitle: Text(comments.elementAt(index).body ?? ''),
                        trailing: Text(
                          comments.elementAt(index).date ?? '',
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.grey.shade300),
                        ),
                      ),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: comments.length);
            },
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextInput(
                      label: 'اكتب تعليق',
                      enableHint: true,
                      textHeight: 1.2,
                      controller: comment,
                      onEditComplete: () {
                        FocusScope.of(context).unfocus();
                      }),
                ),
                IconButton(
                    onPressed: () {
                      if (comment.text.isNotEmpty) {
                        comments.add(CommentModel.comment(body: comment.text));
                        FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postId)
                            .collection('comments')
                            .add(CommentModel.comment(body: comment.text)
                                .toMap());
                        FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.postId)
                            .update({'commentsCount': FieldValue.increment(1)});
                        comment.text = '';
                        setState(() {});
                      }
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
