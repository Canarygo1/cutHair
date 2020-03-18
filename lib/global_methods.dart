import 'dart:io';

import 'package:flutter/material.dart';

class globalMethods{

  BuildContext context;


  void pushPage(BuildContext context, Widget page){
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
  
  void popPage(BuildContext page){
    Navigator.pop(page);
  }

  Future<bool> onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        title: Text('¿Seguro que quieres salir?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          FlatButton(
            onPressed: () => exit(0),
            child: Text(
              'Sí',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }
}