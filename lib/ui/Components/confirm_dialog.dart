import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/textTypes/small_text.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatefulWidget {
  Widget widget;
  Function function;
  bool multiOptions;
  BuildContext context;

  ConfirmDialog(this.widget, this.function, {this.multiOptions = true});

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  double HEIGHT;
  double WIDHT;

  @override
  void initState() {
    widget.context = context;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    Widget button = widget.multiOptions == true ? buttonsOptions() : buttonSimple();
    return AlertDialog(
      backgroundColor: Color.fromRGBO(30, 31, 32, 1),
      title: Center(child: widget.widget),
      content: button,
    );
  }

  Widget buttonsOptions() {
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

  Widget buttonSimple() {
    return MyButton(
              () => GlobalMethods().popPage(context),
          SmallText('Aceptar'),
          color: Color.fromRGBO(230, 73, 90, 1),
          height: HEIGHT * 0.05,

    );
  }
}
