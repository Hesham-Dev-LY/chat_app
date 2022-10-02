import 'package:chat_app/model/post_model.dart';
import 'package:chat_app/views/core/home/view_comments.dart';
import 'package:chat_app/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/helperFunctions.dart';
import 'full_image.dart';

class PostItem extends StatefulWidget {
  const PostItem(
      {required this.model,
      Key? key,
      this.onPostDeleted,
      required this.onCommentClick,
      required this.owner})
      : super(key: key);
  final PostModel model;
  final bool owner;
  final Function() onCommentClick;
  final Function()? onPostDeleted;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        shadowColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: .5,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      widget.model.userName ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(fontSize: 16.0, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    Text(
                      widget.model.date ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.model.description ?? '',
                  textAlign: TextAlign.right,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(height: 1.5),
                ),
              ),
              if (widget.model.image != null)
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FullImage(image: widget.model.image!),
                          ));
                    },
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(10),
                      child: Hero(
                        tag: widget.model.image!,
                        child: loadPhoto(
                            url: widget.model.image!,
                            height: 250,
                            width: double.infinity),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${widget.model.commentsCount} تعليق - ${widget.model.likes.length} إعجاب',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 14.0),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Container(
                color: Colors.grey.shade200,
                child: Builder(builder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 35.0,
                        child: defaultButton(
                            label: 'التعليق',
                            smalSize: true,
                            radius: 5,
                            backgroundColor: Colors.transparent,
                            textColor: Colors.blueGrey,
                            onClick: () {
                              widget.onCommentClick();
                            },
                            icon: Icons.chat_outlined),
                      ),
                      Container(
                        color: Colors.white,
                        width: 1.0,
                        height: 20,
                      ),
                      Container(
                        height: 35.0,
                        child: Center(
                          child: defaultButton(
                              label: widget.model.isLiked
                                  ? 'إلغاء الإعجاب'
                                  : 'اعجاب',
                              smalSize: true,
                              radius: 5,
                              backgroundColor: Colors.transparent,
                              textColor: Colors.blueGrey,
                              onClick: () {
                                like(
                                    postId: widget.model.postId!,
                                    like: !widget.model.isLiked);
                                setState(() {
                                  widget.model.isLiked = !widget.model.isLiked;
                                  if (!widget.model.isLiked)
                                    widget.model.likes.remove(
                                        '${FirebaseAuth.instance.currentUser!.uid}');
                                  else
                                    widget.model.likes.add(
                                        '${FirebaseAuth.instance.currentUser!.uid}');
                                });
                              },
                              icon: widget.model.isLiked
                                  ? Icons.thumb_up_alt_rounded
                                  : Icons.thumb_up_off_alt),
                        ),
                      ),
                      if (widget.owner)
                        Container(
                          color: Colors.white,
                          width: 1.0,
                          height: 20,
                        ),
                      if (widget.owner)
                        Center(
                          child: Container(
                            height: 35.0,
                            child: defaultButton(
                                label: 'حذف',
                                smalSize: true,
                                radius: 5,
                                backgroundColor: Colors.transparent,
                                textColor: Colors.red,
                                onClick: () async {
                                  try {
                                    showToast('جاري الحذف');
                                    await FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(widget.model.postId!)
                                        .delete();
                                    if ((widget.onPostDeleted) != null) {
                                      widget.onPostDeleted!();
                                    }
                                    showToast('تم الحذف');
                                  } catch (ex) {
                                    showToast('فشل الحذف');
                                  }
                                },
                                icon: Icons.delete_forever),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
