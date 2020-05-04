import 'package:cuthair/global_methods.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatefulWidget {
  Widget widget;
  Function function;
  BuildContext context;
  ConfirmDialog(this.widget, this.function);

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {

  @override
  void initState() {
    widget.context = this.context;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(30, 31, 32, 1),
      title: widget.widget,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0)),
              child: Text(
                "No",
                style: TextStyle(color: Colors.white),
              ),
              color: Color.fromRGBO(230, 73, 90, 1),
              onPressed: () => {
                GlobalMethods().popPage(context),
              }),
          FlatButton(
            key: Key('yesDialogText'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0)),
            child: Text(
              "Sí",
              style: TextStyle(color: Colors.white),
            ),
            color: Color.fromRGBO(230, 73, 90, 1),
            onPressed: widget.function,
          ),
        ],
      ),
    );
  }
}