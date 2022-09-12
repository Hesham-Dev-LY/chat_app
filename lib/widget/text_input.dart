import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextInput extends StatelessWidget {
  MyTextInput(
      {TextInputType inputType = TextInputType.text,
      TextAlign align = TextAlign.start,
      bool readOnly = false,
      bool enabled = true,
      this.isPassword = false,
      this.enableHint = false,
      this.horizontalScroll = false,
      this.enabledBorder = true,
      this.fontSize = 16.0,
      this.iconSize = 30.0,
      this.radius = 10,
      this.maxLength,
      this.onTap,
      TextInputAction? inputAction,
      String? value,
      String? hint,
      String? sufix,
      Color textColor = Colors.blue,
      this.onChanged,
      Color? borderColor,
      Color? backColor,
      this.focusScope,
      this.autoFocus = false,
      double? height = 50.0,
      double textHeight = 1.5,
      TextEditingController? controller,
      IconData? icon,
      String? imIcon,
      required this.label,
      required this.onEditComplete,
      this.maxLines = 1,
      this.textDir,
      Key? key})
      : super(key: key) {
    this.onEditComplete = onEditComplete;
    this.inputType = inputType;
    this.align = align;
    this.enabled = enabled;
    this.readOnly = readOnly;
    this.inputAction = inputAction;
    this.controller = controller;
    this.borderColor = borderColor;
    this.textColor = textColor;
    this.value = value;
    this.sufix = sufix;
    this.hint = hint;

    this.icon = icon;
    this.textHeight = textHeight;
    this.height = height;
    this.enabledBorder = enabledBorder;
    this.backColor = backColor;
    this.imIcon = imIcon;
  }

  TextEditingController? controller;
  TextInputType? inputType;
  double? height, textHeight;
  double fontSize;
  TextAlign? align;
  String label;
  String? hint, value, imIcon, sufix;
  double radius;
  int? maxLines;
  int? maxLength;
  IconData? icon;
  double iconSize;
  FocusNode? focusScope;
  bool? readOnly, enabled;
  bool isPassword;
  bool enabledBorder, enableHint, autoFocus;
  TextInputAction? inputAction;
  Function onEditComplete;
  Color? textColor, borderColor, backColor;
  void Function()? onTap;
  bool horizontalScroll;
  TextDirection? textDir;
  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
          keyboardType: inputType,
          //   textDirection: textDirection,
          textAlign: align!,
          readOnly: readOnly ?? true,
          textDirection: isPassword ? TextDirection.rtl : textDir,
          //textDirection: textDir,
          textAlignVertical: TextAlignVertical.top,
          textInputAction: inputAction ?? TextInputAction.next,
          controller: controller,
          enabled: enabled,
          focusNode: focusScope,
          onTap: onTap,
          autofocus: autoFocus,
          onChanged: onChanged,
          maxLength: maxLength,
          cursorColor: textColor,
          initialValue: value,
          scrollPhysics: BouncingScrollPhysics(),
          maxLines: maxLines,
          onEditingComplete: () => onEditComplete(),
          obscureText: isPassword,
          style: TextStyle(
            fontSize: fontSize,
            height: textHeight,
            color: textColor ?? Colors.black,
            overflow: TextOverflow.ellipsis,
            fontFamily: 'Madani Arabic Regular',
          ),
          decoration: InputDecoration(
              labelText: enableHint ? null : label,
              contentPadding: horizontalScroll
                  ? const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0)
                  : null,
              counterStyle: TextStyle(
                height: double.minPositive,
                color: textColor,
              ),
              counterText: "",
              labelStyle:
                  TextStyle(color: textColor?.withOpacity(0.7), height: 1.5),
              hintStyle:
                  TextStyle(color: textColor?.withOpacity(0.7), height: 0.5),
              hintText: hint ?? (enableHint ? label : null),
              hoverColor: textColor ?? Colors.black,
              enabledBorder:
                  defaultBorder(border: radius, enable: enabledBorder),
              filled: backColor != null,
              fillColor: backColor,
              border: defaultBorder(border: radius, enable: enabledBorder),
              focusedBorder: defaultBorder(
                  hoverd: true,
                  border: radius,
                  borderColor: borderColor,
                  enable: enabledBorder),
              suffixIcon: icon != null
                  ? Icon(
                      icon,
                      color: textColor,
                      size: iconSize + 8,
                    )
                  : imIcon != null
                      ? ImageIcon(
                          AssetImage(imIcon!),
                          size: iconSize / 2,
                          color: textColor,
                        )
                      : sufix != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                sufix ?? '',
                                style: TextStyle(
                                    color: Colors.black,
                                    height: textHeight! + .8),
                                textDirection: TextDirection.ltr,
                              ))
                          : null)),
    );
  }

  InputBorder defaultBorder(
          {bool hoverd = false,
          bool enable = true,
          Color? borderColor,
          double border = 10}) =>
      OutlineInputBorder(
        borderSide: enable
            ? BorderSide(
                color: borderColor == null
                    ? hoverd
                        ? Colors.blue
                        : Colors.grey.shade300
                    : borderColor,
                width: hoverd ? 1.5 : 0.8)
            : BorderSide(width: 0.0, color: borderColor ?? Colors.white),
        borderRadius: BorderRadius.circular(border),
      );
}
