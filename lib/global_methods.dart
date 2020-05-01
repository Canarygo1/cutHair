
import 'package:cuthair/ui/Components/SlideRightRoute.dart';
import 'package:flutter/material.dart';

class globalMethods{

  BuildContext context;


  void pushPage(BuildContext context, Widget page){
    Navigator.of(context).push(
      SlideRightRoute(page: page),
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