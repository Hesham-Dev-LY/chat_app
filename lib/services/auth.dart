import 'package:chat_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Set uid to "UserOfFirebase" Class
  UserOfFirebase? _userFromFirebaseUser(User? firebaseUser) {
    return firebaseUser != null
        ? UserOfFirebase(userId: firebaseUser.uid)
        : null;
  }

  // ============================================================== //
  Future signInWithEmailAndPassword(String email, String pwd, context) async {
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(email: email, password: pwd);
      User? firebaseUser = credential.user;
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('بيانات غير صحيحة'),
            content:
                Text('الرجاء التأكد من البريد الإلكتروني وكلمة المرور    '),
            actions: <Widget>[
              TextButton(
                child: Text('إغلاق'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        },
      );
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String pwd, context) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: pwd);
      User? firebaseUser = credential.user;
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('بيانات غير صحيحة'),
            content:
                Text('الرجاء التأكد من البريد الإلكتروني وكلمة المرور    '),
            actions: <Widget>[
              TextButton(
                child: Text('إغلاق'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        },
      );
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  // ======================================================== //
  // SignIN and SignUp with Google
  final auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  late String email;
  late String name;
  late String imageUrl;
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken);

    final UserCredential? authResult =
        await auth.signInWithCredential(credential);
    final User? user = authResult?.user;

    assert(user?.email != null);
    assert(user?.displayName != null);
    assert(user?.photoURL != null);

    name = user!.displayName!;
    email = user.email!;
    imageUrl = user.photoURL!;

    final User currentUser = auth.currentUser!;
    assert(user.uid == currentUser.uid);
    return 'signInWithGoogle succeeded : $user';
  }

  // ======================================================== //
  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
