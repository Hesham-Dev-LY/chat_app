import 'package:chat_app/helper/helperFunctions.dart';
import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {
  const FullImage({required this.image, Key? key}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عرض الصورة'),
        centerTitle: true,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Hero(
            tag: image,
            child: loadPhoto(
                url: image, width: double.infinity, bf: BoxFit.fitWidth),
          )),
    );
  }
}
