import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  TextEditingController controller;
  TextInputType textType;
  Color cursorColor;
  InputDecoration decoration;
  TextStyle textStyle;
  int maxLength;
  Function onchangeFunction;
  bool obscureText;
  ToolbarOptions toolbarOptions;

  MyTextField(this.controller, this.textType, this.decoration, this.textStyle,
      {this.cursorColor = Colors.white,
        this.maxLength,
        this.onchangeFunction,
        this.obscureText = false, this.toolbarOptions});

  @override
  Widget build(BuildContext context) {
    return TextField(
        enableInteractiveSelection: false,
        toolbarOptions: toolbarOptions,
        controller: controller,
        keyboardType: textType,
        cursorColor: cursorColor,
        decoration: decoration,
        style: textStyle,
        maxLength: maxLength,
        obscureText: obscureText,
        onChanged: onchangeFunction);
  }
}
