import 'dart:io';

import 'package:cuthair/TestStripe/services/payment-service.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  onItemPress(BuildContext context, int index) async {
    switch(index) {
      case 0:
        payViaNewCard(context);
        break;
      case 1:
        StripeService.payWithNativeCards("20", "EUR");
    }
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(
        message: 'Please wait...'
    );
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        amount: '200',
        currency: 'EUR'
    );
    await dialog.hide();

    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
  var platform = Theme.of(context).platform;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 73, 90, 1),
        title: LargeText("Métodos de pago"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              Icon icon;
              MediumText text;
              switch(index) {
                case 0:
                  icon = Icon(Icons.add_circle, color: Colors.white);
                  text = MediumText('Nueva tarjeta');
                  break;
                case 1:
                  icon = Icon(Icons.credit_card, color: Colors.white);
                  text = MediumText(
                    platform == TargetPlatform.iOS ? 'Pagar con Apple pay'
                        : 'Pagar con Google pay'
                  );
              }
              return InkWell(
                onTap: () {
                  onItemPress(context, index);
                },
                child: ListTile(
                  title: text,
                  leading: icon,
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              color: Colors.white,
              thickness: 2,
            ),
            itemCount: 2
        ),
      ),
    );;
  }
}