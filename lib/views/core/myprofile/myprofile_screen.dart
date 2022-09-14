import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/views/core/myprofile/view_personal_info.dart';
import 'package:chat_app/views/signin.dart';
import 'package:chat_app/widget/view_posts.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('حسابي'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _itemBuilder(
                icon: Icons.newspaper,
                title: 'منشوراتي',
                fun: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                            appBar: AppBar(
                              title: Text('منشوراتي'),
                              centerTitle: true,
                            ),
                            body: ViewPosts(myPosts: true)),
                      ));
                },
                color: Colors.blue.shade900),
            _itemBuilder(
                icon: Icons.person_pin_rounded,
                title: 'بياناتي الشخصية',
                fun: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPersonalInfoScreen(),
                      ));
                },
                color: Colors.black),
            _itemBuilder(
                icon: Icons.logout_outlined,
                title: 'تسجيل الخروج',
                fun: () {
                  showToast('جاري تسجيل الخروج');
                  AuthMethods().auth.signOut().then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ),
                        (route) => false);
                  }).catchError((eror) {
                    showToast("فشل تسجيل الخروج", error: true);
                  });
                },
                color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(
          {required IconData icon,
          required String title,
          required Function() fun,
          Color color = Colors.grey}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(color: color),
          ),
          onTap: fun,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: color.withOpacity(.1),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          trailing: Icon(
            icon,
            color: color,
          ),
        ),
      );
}
