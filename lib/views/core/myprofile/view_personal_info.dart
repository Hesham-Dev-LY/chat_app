import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/widget/text_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewPersonalInfoScreen extends StatefulWidget {
  const ViewPersonalInfoScreen({Key? key}) : super(key: key);

  @override
  State<ViewPersonalInfoScreen> createState() => _ViewPersonalInfoScreenState();
}

class _ViewPersonalInfoScreenState extends State<ViewPersonalInfoScreen> {
  TextEditingController uname = TextEditingController();

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اسم المستخدم'),
            SizedBox(
              height: 8,
            ),
            MyTextInput(
              label: '',
              onEditComplete: () {},
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
              onEditComplete: () {},
              value: FirebaseAuth.instance.currentUser!.email,
            ),
          ],
        ),
      ),
    );
  }
}
