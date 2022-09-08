import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/views/chatRoomScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // -------------------------------------------------------------- //
  bool? userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    }).catchError((err) {
      userIsLoggedIn = false;
    });
  }

  // -------------------------------------------------------------- //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xff1F1F1F),
          primaryColor: Color(0xff145C9E),
          primarySwatch: Colors.blue,
          accentColor: Color(0xff007EF4),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: userIsLoggedIn == null
            ? Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : (userIsLoggedIn!)
                ? ChatRoom()
                : Authenticate());
  }
}
