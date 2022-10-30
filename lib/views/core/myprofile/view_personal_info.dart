import 'dart:io';

import 'package:chat_app/helper/default_button.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/views/core/home/add_post_screen.dart';
import 'package:chat_app/widget/text_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ViewPersonalInfoScreen extends StatefulWidget {
  const ViewPersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<ViewPersonalInfoScreen> createState() => _ViewPersonalInfoScreenState();
}

class _ViewPersonalInfoScreenState extends State<ViewPersonalInfoScreen> {
  TextEditingController uname = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  XFile? _selectedImg;
  bool isLoading = false;
  bool changePassword = false;

  @override
  void initState() {
    // TODO: implement initState
    HelperFunctions.getUserNameSharedPreference()
        .then((value) => uname.text = value ?? '---');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('بياناتي الشخصية'),
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(150.0),
                    onTap: () {
                      okCancelDialog(context, 'تنبيه',
                              message: 'هل تريد تغيير الصورة الشخصية ؟',
                              showCancelButton: true)
                          .then((value) async {
                        if (value != null && value == true) {
                          final ImagePicker _picker = ImagePicker();
                          // Pick an image
                          _selectedImg = await _picker.pickImage(
                              source: ImageSource.gallery,
                              maxWidth: 512,
                              maxHeight: 512,
                              imageQuality: 80);
                          if (_selectedImg != null) {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              String? link = await uploadFile(_selectedImg!,
                                  profileImg: true);
                              if (link == null) {
                                showToast("فشل رفع الصورة");
                              } else {
                                await FirebaseAuth.instance.currentUser!
                                    .updatePhotoURL(link);
                                await FirebaseFirestore.instance
                                    .collection('chatUsers')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({'image': link});
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            } catch (ex) {
                              showToast('الرجاء التحقق من أتصالك بالأنترنت');
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        }
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blue, width: 5.0),
                      ),
                      child: _selectedImg != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(150.0),
                              clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                File(_selectedImg!.path),
                                height: 150.0,
                                fit: BoxFit.cover,
                              ))
                          : FirebaseAuth.instance.currentUser!.photoURL == null
                              ? Center(
                                  child: Text(
                                  'إضافة صورة',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                        fontSize: 14.0,
                                        height: 1.5,
                                      ),
                                ))
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(150.0),
                                  clipBehavior: Clip.antiAlias,
                                  child: loadPhoto(
                                      url: FirebaseAuth
                                          .instance.currentUser!.photoURL!,
                                      height: 150.0)),
                    ),
                  ),
                ),
              ),
              Text('اسم المستخدم'),
              SizedBox(
                height: 8,
              ),
              MyTextInput(
                label: '',
                onEditComplete: () {},
                readOnly: true,
                value: (FirebaseAuth.instance.currentUser!.displayName) ??
                    uname.text,
              ),
              Divider(
                height: 50,
              ),
              Text('البريد الإلكتروني'),
              SizedBox(
                height: 8,
              ),
              MyTextInput(
                label: '',
                readOnly: true,
                onEditComplete: () {},
                value: FirebaseAuth.instance.currentUser!.email,
              ),
              Divider(
                height: 50,
              ),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                child: changePassword
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('كلمة المرور الجديدة'),
                          SizedBox(
                            height: 8,
                          ),
                          MyTextInput(
                            label: '',
                            onEditComplete: () {
                              FocusScope.of(context).unfocus();
                            },
                            isPassword: true,
                            controller: newPassword,
                          ),
                        ],
                      )
                    : SizedBox(),
              ),
              if (changePassword)
                SizedBox(
                  height: 8,
                ),
              DefaultButton(
                  onClick: () async {
                    if (!changePassword) {
                      setState(() {
                        changePassword = true;
                      });
                      return;
                    }
                    try {
                      if (changePassword) {
                        String newPass = newPassword.text.trim();
                        if (newPass.isEmpty || newPass.length < 6) {
                          okCancelDialog(context, "بيانات خاطئة",
                              message:
                                  'الرجاء التاكد من كتابة كلمة المرور بشكل صحيح بطول 6 خانات او اكثر');
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          await FirebaseAuth.instance.currentUser!
                              .updatePassword(newPass);
                          showToast('تم تغيير كلمة المرور');
                        }
                      }
                    } catch (ex) {
                      print('EX : ${ex.toString()}');
                      if (ex.toString().contains('recent authentication')) {
                        showToast('الرجاء إعادة تسجيل الدخول وإعادة المحاولة',
                            error: true);
                      } else
                        showToast(
                            'الرجاء التحقق من اتصالك بالأنترنت وإعادة المحاولة',
                            error: true);
                    } finally {
                      if (newPassword.text.length >= 6)
                        setState(() {
                          isLoading = false;
                          changePassword = false;
                        });
                    }
                  },
                  backColor: Colors.blue,
                  textColor: Colors.white,
                  icon: changePassword ? Icons.save : Icons.lock_reset_outlined,
                  label: changePassword ? 'حفظ التعديل' : 'تغيير كلمة المرور'),
              if (changePassword)
                SizedBox(
                  height: 8,
                ),
              if (changePassword)
                DefaultButton(
                  onClick: () {
                    setState(() {
                      changePassword = false;
                    });
                  },
                  label: 'إلغاء الأمر',
                  backColor: Colors.white,
                  textColor: Colors.grey,
                ),
            ],
          ),
        );
      }),
    );
  }
}
