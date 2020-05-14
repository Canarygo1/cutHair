import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/textTypes/small_text.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatefulWidget {
  Widget widget;
  Function function;
  Widget buttons;
  BuildContext context;

  ConfirmDialog(this.widget, this.function, {this.buttons});

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  double HEIGHT;
  double WIDHT;

  @override
  Widget build(BuildContext context) {
    if (widget.buttons == null) widget.buttons = buttons();
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: Color.fromRGBO(30, 31, 32, 1),
      title: Center(child: widget.widget),
      content: widget.buttons,
    );
  }

  Widget buttons() {
    return Row(
      children: <Widget>[
        MyButton(
          () => GlobalMethods().popPage(context),
          SmallText('No'),
          color: Color.fromRGBO(230, 73, 90, 1),
          height: HEIGHT * 0.04,
        ),
        MyButton(widget.function, SmallText('Sí'),
            color: Color.fromRGBO(230, 73, 90, 1), height: HEIGHT * 0.04),
      ],
    );
  }
}
