import 'package:flutter/material.dart';

AppBar appBarMain(BuildContext context) {
  return AppBar(
    centerTitle: true,
    title: Text('My Chat App'),
  );
}

InputDecoration textFieldInputDecoration(String labelText, Icon iconType) {
  return InputDecoration(
    focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(10)),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10)),
    prefixIcon: iconType,
    labelText: labelText,
    prefixIconColor: Colors.black,
    iconColor: Colors.black,
    filled: true,
    fillColor: Colors.grey.shade300,
    labelStyle: TextStyle(color: Colors.black),
  );
}

TextStyle simpleTextStyle({Color color = Colors.white}) {
  return TextStyle(fontSize: 16.0, color: color);
}

TextStyle chatRoomTileStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: 'OverpassRegular',
    fontWeight: FontWeight.w300,
  );
}

Widget defaultButton(
    {Color? backgroundColor,
    Color textColor = Colors.blue,
    required Function onClick,
    String? label,
    double radius = 15.0,
    bool spread = false,
    bool enableBorder = false,
    bool smalSize = false,
    IconData? icon}) {
  if (backgroundColor == null) {
    backgroundColor = Colors.blue;
    textColor = Colors.white;
  }
  return Container(
    height: 45,
    decoration: BoxDecoration(
      color: backgroundColor,
      border: Border.all(
          color: textColor,
          width: enableBorder ? 1.0 : 0.0,
          style: enableBorder ? BorderStyle.solid : BorderStyle.none),
      borderRadius: BorderRadius.circular(radius),
    ),
    child: MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      onPressed: () => onClick(),
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (label == null)
                Container(
                  width: 0.0,
                ),
              if (label != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 4.0),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'JF Flat Regular',
                      color: backgroundColor == Colors.blue
                          ? Colors.white
                          : textColor,
                      fontSize: smalSize ? 14.0 : 18.0,
                    ),
                  ),
                ),
              if (!spread && icon != null)
                Icon(
                  icon,
                  size: smalSize ? 16 : 20,
                  color:
                      backgroundColor == Colors.blue ? Colors.white : textColor,
                ),
            ],
          ),
          if (spread)
            Icon(
              icon,
              size: smalSize ? 16 : 20,
              color: backgroundColor == Colors.blue ? Colors.white : textColor,
            ),
        ],
      ),
    ),
  );
}
