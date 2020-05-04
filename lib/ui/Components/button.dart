import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  Function function;
  Widget widget;
  var height;
  var horizontalPadding;
  var verticalMargin;

  MyButton(this.function, this.widget, {this.height, this.horizontalPadding = 35.0, this.verticalMargin = 10.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height == null ? MediaQuery.of(context).size.height * 0.081 : height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      child: FlatButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        color: Color.fromRGBO(230, 73, 90, 1),
        child: widget,
        onPressed:function,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}