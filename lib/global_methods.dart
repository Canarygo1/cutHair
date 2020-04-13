import 'dart:io';

import 'package:flutter/material.dart';

class globalMethods{

  BuildContext context;


  void pushPage(BuildContext context, Widget page){
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  void PushAndReplacement(BuildContext context, Widget widget){
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => widget));
  }

  void popPage(BuildContext page){
    Navigator.pop(page);
  }
}