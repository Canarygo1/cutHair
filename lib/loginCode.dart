import 'package:flutter/material.dart';

class loginCode{

 void pushPage(BuildContext context, Widget page){
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
 }


}