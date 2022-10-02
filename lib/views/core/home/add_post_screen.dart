import 'dart:io';
import 'dart:math';

import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/widget/text_input.dart';
import 'package:chat_app/widget/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/post_model.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isLoading = false;
  TextEditingController des = TextEditingController();
  TextEditingController imageTxt = TextEditingController(text: 'إضافة صورة');
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('اضافة منشور'),
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        if (isLoading) return Center(child: CircularProgressIndicator());
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextInput(
                  label: '',
                  enableHint: true,
                  height: null,
                  maxLines: 1,
                  radius: 10,
                  borderColor: Colors.black,
                  icon: image == null ? null : Icons.check_rounded,
                  controller: imageTxt,
                  readOnly: true,
                  onTap: () async {
                    try {
                      image = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (image == null) {
                        showToast("لم يتم اختيار الصورة");
                        imageTxt.text = 'إضافة صورة';
                      } else {
                        print(image!.path);
                        imageTxt.text = 'تم أختيار صورة ';
                      }
                    } catch (ex) {
                    } finally {
                      setState(() {});
                    }
                  },
                  inputAction: TextInputAction.done,
                  onEditComplete: () {
                    FocusScope.of(context).unfocus();
                  }),
              SizedBox(
                height: 16.0,
              ),
              MyTextInput(
                  label: 'شارك افكارك ؟',
                  height: null,
                  maxLines: 10,
                  enableHint: true,
                  controller: des,
                  radius: 10,
                  inputAction: TextInputAction.done,
                  onEditComplete: () {
                    FocusScope.of(context).unfocus();
                  }),
              SizedBox(
                height: 16.0,
              ),
              defaultButton(
                  onClick: () {
                    if (des.text.isEmpty) {
                      showToast("لا يمكن نشر محتوى فارغ");
                    } else {
                      post();
                    }
                  },
                  label: 'نشر',
                  radius: 10)
            ],
          ),
        );
      }),
    );
  }

  Future<void> post() async {
    setState(() {
      isLoading = true;
    });
    try {
      String? imgUrl;
      if (image != null) {
        imgUrl = await uploadFile(image!);
      }
      FirebaseFirestore.instance.collection('posts').doc().set(
          await PostModel.newPost(description: des.text.trim(), image: imgUrl)
              .toMap());
      showToast('تم النشر', error: false);
      Navigator.pop(context);
    } catch (ex) {
      print(ex.toString());
      showToast('فشل النشر', error: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

Future<String?> uploadFile(XFile file, {bool profileImg = false}) async {
  try {
    print('START:');
    Reference ref = FirebaseStorage.instance
        .ref()
        .child(profileImg ? 'profile' : 'posts')
        .child('/${file.name}.jpg');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );
    await ref.putFile(File(file.path), metadata);
    return await ref.getDownloadURL();
  } catch (ex) {
    print('ERROR ______ : ${ex}');
    return null;
  }
}
