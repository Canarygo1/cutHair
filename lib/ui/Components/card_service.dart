import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Pages/choose_hairdresser/choose_hairdresser.dart';
import 'package:flutter/material.dart';

class CardService extends StatelessWidget {
  List<Service> detallesServicio = [];
  HairDressing hairDressing;
  Appointment appointment = Appointment();
  Function function;

  CardService(this.hairDressing, this.detallesServicio, this.function);

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
            GlobalMethods()
                .pushPage(context, chooseHairDresserScreen(appointment));
          },
          child: Card(
            shape: BeveledRectangleBorder(
                side: BorderSide(color: Color.fromRGBO(300, 300, 300, 1))),
            child: Container(
              color: Color.fromRGBO(300, 300, 300, 1),
              child: Column(
                children: [
                  cardServices(context, index),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.013),
                            child: Divider(
                              thickness: 0.6,
                              endIndent: 10.0,
                              indent: 5.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget cardServices(BuildContext context, int index) {
    if (detallesServicio[index].duration == "llamada") {
      return GestureDetector(
        onTap: function,
        child: ListTile(
          contentPadding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
          dense: true,
          title: LargeText(detallesServicio[index].type),
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
        title: LargeText(detallesServicio[index].type),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                  detallesServicio[index].duration.toString() + " minutos",
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(detallesServicio[index].price.toString() + " €",
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
            )
          ],
        ),
      );
    }
  }
}
