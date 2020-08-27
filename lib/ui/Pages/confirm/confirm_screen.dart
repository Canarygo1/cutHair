import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/components.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/BusinessComponents/Beach/main_class_beach.dart';
import 'package:cuthair/ui/BusinessComponents/HairDressing/main_class_hairdressing.dart';
import 'package:cuthair/ui/BusinessComponents/Restaurant/main_class_restaurant.dart';
import 'package:cuthair/ui/Pages/confirm/confirm_presenter.dart';
import 'package:cuthair/ui/Pages/confirm_animation/confirm_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmScreen extends StatefulWidget {
  Appointment appointment;

  ConfirmScreen(this.appointment);

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState(appointment);
}

class _ConfirmScreenState extends State<ConfirmScreen> implements ConfirmView {
  Appointment appointment;
  Widget screen;
  List<User> listUser;
  bool penalize = false;
  ConfirmPresenter presenter;
  RemoteRepository _remoteRepository;
  double HEIGHT;
  double WIDHT;

  _ConfirmScreenState(this.appointment);

  initState() {
    super.initState();
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = ConfirmPresenter(this, _remoteRepository);
    presenter.init(DBProvider.users[0].uid);
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      body: SingleChildScrollView(child: getConfirmScreen()),
    );
  }

  Widget getConfirmScreen() {
    if (appointment.business.typeBusiness == "Peluquerías") {
      return ConfirmScreenHairDressing().getConfirmHairDressing(appointment, this.HEIGHT, this.WIDHT, penalize, context, buttonConfirm(), buttonCancel());
    } else if (appointment.business.typeBusiness == "Restaurantes") {
      return ConfirmScreenRestaurant().getConfirmRestaurant(appointment, this.HEIGHT, this.WIDHT, penalize, context, buttonConfirm(), buttonCancel());
    } else {
      return ConfirmScreenBeach().getConfirmBeach(appointment, this.HEIGHT, this.WIDHT, penalize, context, buttonConfirm(), buttonCancel());
    }
  }

  Widget buttonConfirm() {
    return Expanded(
      child: Components.smallButton(
        () => {
          ConnectionChecked.checkInternetConnectivity(context),
          GlobalMethods()
              .pushAndReplacement(context, ConfirmAnimation(appointment))
        },
        Components.largeText("Confirmar"),
        horizontalPadding: WIDHT * 0.025,
        color: Color.fromRGBO(230, 73, 90, 1),
        height: HEIGHT * 0.067,
      ),
    );
  }

  Widget buttonCancel() {
    return Expanded(
      child: Components.smallButton(
        () => {
          ConnectionChecked.checkInternetConnectivity(context),
          GlobalMethods().removePages(context)
        },
        Components.largeText("Cancelar"),
        horizontalPadding: WIDHT * 0.025,
        color: Color.fromRGBO(230, 73, 90, 1),
        height: HEIGHT * 0.067,
      ),
    );
  }

  @override
  showPenalize(bool penalize) {
    if (mounted) {
      setState(() {
        this.penalize = penalize;
      });
    }
  }
}
