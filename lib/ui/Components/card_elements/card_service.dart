import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:cuthair/ui/Pages/choose_extra_info/choose_extra_info.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CardService extends StatelessWidget {
  List<Service> servicesDetails = [];
  Business business;
  Appointment appointment = Appointment();
  double HEIGHT;
  double WIDHT;

  CardService(this.business, this.servicesDetails);

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: servicesDetails.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            appointment.service = servicesDetails[index];
            appointment.business = business;
            GlobalMethods()
                .pushPage(context, ChooseExtraInfoScreen(appointment));
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
                            padding: EdgeInsets.only(top: HEIGHT * 0.013),
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
    if (servicesDetails[index].duration == "llamada") {
      return GestureDetector(
        onTap: () => makecall(business.phoneNumber.toString()),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: WIDHT * 0.05),
          dense: true,
          title: LargeText(servicesDetails[index].type),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: HEIGHT * 0.013),
                child: MediumText(
                  "Llame al número para más información",
                  boolText: FontWeight.normal,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: HEIGHT * 0.013),
                child: MediumText(
                    "Teléfono: " + business.phoneNumber.toString(),
                    boolText: FontWeight.normal),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.phone, color: Color.fromRGBO(230, 73, 90, 1)),
          ),
        ),
      );
    } else {
      return ListTile(
        contentPadding: EdgeInsets.only(left: WIDHT * 0.05),
        dense: true,
        title: LargeText(servicesDetails[index].type),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: HEIGHT * 0.013),
              child: MediumText(
                  servicesDetails[index].duration.toString() + " minutos",
                  boolText: FontWeight.normal),
            ),
            Padding(
              padding: EdgeInsets.only(top: HEIGHT * 0.013),
              child: MediumText(servicesDetails[index].price.toString() + " €",
                  boolText: FontWeight.normal),
            )
          ],
        ),
      );
    }
  }

  makecall(String number) async {
    await launch("tel:" + "+34" + number);
  }
}
