import 'package:chat_app/views/chatRoomScreen.dart';
import 'package:chat_app/views/home_screen.dart';
import 'package:flutter/material.dart';

class CoreScreen extends StatefulWidget {
  const CoreScreen({Key? key}) : super(key: key);

  @override
  State<CoreScreen> createState() => _CoreScreenState();
}

class _CoreScreenState extends State<CoreScreen> {
  int screenIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [Container(), HomeScreen(), ChatRoom()].elementAt(screenIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper_rounded), label: 'اخر الاخبار'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble), label: 'الدردشة'),
        ],
        backgroundColor: Colors.white,
        elevation: 3.0,
        currentIndex: screenIndex,
        onTap: (index) {
          setState(() {
            screenIndex = index;
          });
        },
      ),
    );
  }
}
