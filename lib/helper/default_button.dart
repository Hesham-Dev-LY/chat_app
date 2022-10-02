import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton({
    required this.onClick,
    required this.label,
    this.enableShadow,
    this.iconAlign = Alignment.centerLeft,
    Color? textColor,
    Color? backColor,
    this.borderColor,
    double fontSize = 16.0,
    double iconSize = 18.0,
    double height = 45.0,
    this.shadowOpacity = 0.3,
    double radius = 10.0,
    bool enableBorder = false,
    String? assetIcon,
    IconData? icon,
    Key? key,
  }) : super(key: key) {
    this.textColor = textColor ?? Colors.blue;
    this.fontSize = fontSize;
    this.height = height;
    this.iconSize = iconSize;
    this.radius = radius;
    this.icon = icon;
    this.assetIcon = assetIcon;
    this.enableBorder = enableBorder;
    backgroundColor = backColor ?? Colors.white;
  }

  final Function() onClick;
  final String label;
  String? assetIcon;
  IconData? icon;
  late Color textColor, backgroundColor;
  late double fontSize, height, radius, iconSize;
  late bool enableBorder;
  bool? enableShadow;
  Alignment iconAlign;
  double shadowOpacity;
  Color? borderColor;

  @override
  Widget build(BuildContext context) {
    //  ScreenUtil.setContext(context);
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
            color: borderColor ?? textColor, width: enableBorder ? 1.0 : 0.0),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: MaterialButton(
        onPressed: onClick,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: BorderSide(
              color: borderColor ?? textColor, width: enableBorder ? 1.0 : 0.0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
              ),
            ),
            if (assetIcon != null)
              Align(
                alignment: iconAlign,
                child: Image.asset(
                  assetIcon!,
                  height: iconSize,
                  fit: BoxFit.fill,
                  color: textColor,
                ),
              ),
            if (icon != null)
              Align(
                  alignment: iconAlign,
                  child: Icon(
                    icon,
                    color: textColor,
                    size: iconSize,
                  )),
          ],
        ),
      ),
    );
  }
}
