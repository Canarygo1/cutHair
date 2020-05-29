
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Components/network_error.dart';
import 'package:flutter/material.dart';
import 'package:simple_connectivity/simple_connectivity.dart';

class ConnectionCheck extends StatefulWidget {
  @override
  ConnectionChecked createState() => ConnectionChecked();
}

class ConnectionChecked extends State<ConnectionCheck>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        color: Color.fromRGBO(300, 300, 300, 1),
          child:  ListView(
            children: <Widget>[
              NetworkError()
            ]
          )
        )
    );
  }
 static checkInternetConnectivity(BuildContext context) async {
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.none){
      GlobalMethods().pushPage(context, ConnectionCheck());
    }
  }
}