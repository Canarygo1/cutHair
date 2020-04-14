import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Components/large_text.dart';
import 'package:cuthair/ui/Pages/choose_hairdresser/choose_hairdresser.dart';
import 'package:flutter/material.dart';

class CardService extends StatelessWidget {
  List<Service> detallesServicio = [];
  HairDressing hairDressing;
  Appointment appointment = Appointment();
  Function funcion;

  CardService(this. hairDressing, this.detallesServicio, this.funcion);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: detallesServicio.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            appointment.service = detallesServicio[index];
            appointment.hairDressing = hairDressing;
            globalMethods()
                .pushPage(context, chooseHairDresserScreen(appointment));
          },
          child: new Card(
            elevation: 0.0,
            shape: BeveledRectangleBorder(
                side: BorderSide(color: Color.fromRGBO(300, 300, 300, 1))),
            child: new Container(
                color: Color.fromRGBO(300, 300, 300, 1),
                child: Column(children: [
                  cardServices(context, index),
                  Container(
                      child: Row(children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Divider(
                          thickness: 0.6,
                          endIndent: 10.0,
                          indent: 5.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ]))
                ])),
          ),
        );
      },
    );
  }

  Widget cardServices(BuildContext context, int index) {
    if (detallesServicio.elementAt(index).duracion == "llamada") {
      return GestureDetector(
        onTap: funcion,
        child: ListTile(
          contentPadding:
          EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
          dense: true,
          title: LargeText(detallesServicio.elementAt(index).tipo),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Llame al número para más información",
                    style: TextStyle(color: Colors.white, fontSize: 16.0)),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                      "Teléfono: " + hairDressing.phoneNumber.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 16.0)))
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.phone, color: Color.fromRGBO(230, 73, 90, 1)),
          ),
        ),
      );
    } else {
      return ListTile(
        contentPadding:
        EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
        dense: true,
        title: Text(detallesServicio.elementAt(index).tipo,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.left),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                  detallesServicio.elementAt(index).duracion.toString() +
                      " minutos",
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                  detallesServicio.elementAt(index).precio.toString() + " €",
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
            )
          ],
        ),
      );
    }
  }
}
