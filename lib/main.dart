import 'package:chat_app/helper/helperFunctions.dart';
import 'package:chat_app/views/core/core_screen.dart';
import 'package:chat_app/views/core/home/home_screen.dart';
import 'package:chat_app/views/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      if (FirebaseAuth.instance.currentUser != null)
        setState(() {
          userIsLoggedIn = value;
        });
      else {
        setState(() {
          userIsLoggedIn = false;
        });
      }
    }).catchError((err) {
      setState(() {
        userIsLoggedIn = false;
      });
    });
  }

  // -------------------------------------------------------------- //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xfff8f8f8),
          primaryColor: Color(0xff145C9E),
          fontFamily: 'JF Flat Regular',
          primarySwatch: Colors.blue,
          accentColor: Color(0xff007EF4),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: const Locale('ar'),
        supportedLocales: const [
          Locale('ar'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: userIsLoggedIn == null
            ? Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : (userIsLoggedIn!)
                ? CoreScreen()
                : SignIn());
  }
}
