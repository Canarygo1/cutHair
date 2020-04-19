import 'package:cuthair/ui/Components/large_text.dart';
import 'package:cuthair/ui/Components/medium_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NetworkError extends StatefulWidget {
  @override
  _NetworkErrorState createState() => _NetworkErrorState();
}

class _NetworkErrorState extends State<NetworkError> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.only(top:170.0),
        child: Center(
          child: Column(
          children: <Widget>[
            LargeText("¡Vaya! Parece que no tienes internet"),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: SvgPicture.asset("assets/images/ufo.svg"),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10),
              child: MediumText("No podemos obtener los datos."),
            ),
            MediumText("Por favor revisa tu conexión a internet")
          ],
          ),
        ));
  }
}
