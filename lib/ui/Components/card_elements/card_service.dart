import 'package:components/components.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/business_type.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Pages/choose_extra_info/choose_extra_info.dart';
import 'package:cuthair/ui/Pages/not_login/not_login.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CardService extends StatelessWidget {
  List<Service> servicesDetails = [];
  Business business;
  Appointment appointment;
  bool logIn;
  double height;
  double width;
  BusinessType typeBusiness;

  CardService(this.appointment, this.business, this.servicesDetails, this.logIn, this.typeBusiness);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: servicesDetails.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return Card(
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
                          padding: EdgeInsets.only(top: height * 0.013),
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
        );
      },
    );
  }

  Widget cardServices(BuildContext context, int index) {
    if (servicesDetails[index].duration == "llamada") {
      return GestureDetector(
        onTap: () => makecall(this.business.phoneNumber.toString()),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: width * 0.05),
          dense: true,
          title: Components.largeText(servicesDetails[index].name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: height * 0.013),
                child: Components.mediumText(
                  "Llame al número para más información",
                  boolText: FontWeight.normal,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.013),
                child: Components.mediumText(
                    "Teléfono: " + business.phoneNumber.toString(),
                    boolText: FontWeight.normal),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () => makecall(this.business.phoneNumber.toString()),
            icon: Icon(Icons.phone, color: Color.fromRGBO(230, 73, 90, 1)),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => tapInService(index, context),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: width * 0.05),
          dense: true,
          title: Components.largeText(servicesDetails[index].name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: height * 0.013),
                child: Components.mediumText(
                    servicesDetails[index].duration + " minutos",
                    boolText: FontWeight.normal),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.013),
                child: Components.mediumText(
                    servicesDetails[index].price + " €",
                    boolText: FontWeight.normal),
              )
            ],
          ),
        ),
      );
    }
  }

  tapInService(int index, BuildContext context){
    if (logIn == true) {
      appointment.serviceId = servicesDetails[index].id;
      appointment.businessId = business.id;
      GlobalMethods()
          .pushPage(context, ChooseExtraInfoScreen(appointment, business, typeBusiness, servicesDetails[index]));
    } else {
      GlobalMethods().pushPage(
          context,
          NotLoginScreen("Reservar cita",
              "Para reservar, necesitas iniciar sesión"));
    }
  }

  makecall(String number) async {
    await launch("tel:" + "+34" + number);
  }
}
