import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/components.dart';
import 'package:components/text_types/medium_text.dart';
import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:cuthair/data/remote/Api/http_api_remote_repository.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/ui/BusinessComponents/Beach/main_class_beach.dart';
import 'package:cuthair/ui/BusinessComponents/HairDressing/main_class_hairdressing.dart';
import 'package:cuthair/ui/BusinessComponents/Restaurant/main_class_restaurant.dart';
import 'package:cuthair/ui/Pages/confirm_animation/confirm_animation_presenter.dart';
import 'package:cuthair/ui/Pages/confirm_animation/progress_painter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:ui';
import 'dart:async';

class ConfirmAnimation extends StatefulWidget {
  ConfirmAnimation(this.appointment) : super();
  Appointment appointment;

  final String title = "Custom Paint Demo";

  @override
  ConfirmAnimationState createState() => ConfirmAnimationState();
}

class ConfirmAnimationState extends State<ConfirmAnimation>
    with SingleTickerProviderStateMixin
    implements ConfirmAnimationView {
  double _percentage;
  double _nextPercentage;
  double _maxPercentage;
  Timer _timer;
  AnimationController _progressAnimationController;
  bool _progressDone;
  Color color = Color.fromRGBO(300, 300, 300, 1);
  bool isAppointmentInsert;
  Widget screen;
  double HEIGHT;
  double WIDHT;
  ConfirmAnimationPresenter _presenter;
  RemoteRepository _remoteRepository;
  Icon statusIcon;
  MediumText confirmTitle;
  MediumText confirmSubtitle;

  @override
  initState() {
    super.initState();
    isAppointmentInsert = false;
    statusIcon =
        Icon(Icons.check_circle_outline, color: Colors.white, size: 150);
    _percentage = 0.0;
    _nextPercentage = 0.0;
    _timer = null;
    _progressDone = false;
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    getConfirmAnimationPresenter();

    _presenter.init(widget.appointment);
    startProgress();
    initAnimationController();
  }

  getConfirmAnimationPresenter(){
    if(this.widget.appointment.business.typeBusiness == "Peluquerías") {

      ApiRemoteRepository _apiRemoteRepository = HttpApiRemoteRepository(Client());

      _presenter = ConfirmAnimationHairDressingPresenter(
          this, _remoteRepository, _apiRemoteRepository);
    }else if(this.widget.appointment.business.typeBusiness == "Restaurantes"){
      _presenter = ConfirmAnimationRestaurantPresenter(
          this, _remoteRepository);
    }else{
      _presenter = ConfirmAnimationBeachPresenter(
          this, _remoteRepository);
    }
  }

  initAnimationController() {
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 10),
    )..addListener(
          () {
        setState(() {
          _percentage = lerpDouble(_percentage, _nextPercentage,
              _progressAnimationController.value);
        });
      },
    );
  }

  start() {
    Timer.periodic(Duration(milliseconds: 30), handleTicker);
  }

  handleTicker(Timer timer) {
    _timer = timer;
    if (_nextPercentage < 100) {
      publishProgress();
    } else {
      timer.cancel();
      setState(() {
        isAppointmentInsert == true ? color = Color.fromRGBO(26, 200, 146, 1) : color = Colors.red;
        _progressDone = true;
      });
    }
  }

  startProgress() {
    if (null != _timer && _timer.isActive) {
      _timer.cancel();
    }
    setState(() {
      _percentage = 0.0;
      _nextPercentage = 0.0;
      _progressDone = false;
      start();
    });
  }

  publishProgress() {
    _percentage = _nextPercentage;
    if (_nextPercentage < _maxPercentage) {
      _nextPercentage += 1;
    }
    if (_nextPercentage > 100.0) {
      _percentage = 0.0;
      _nextPercentage = 0.0;
    }
    _progressAnimationController.forward(from: 0.0);
  }

  getDoneImage() {
    return Container();
  }

  getProgressText() {
    return Text(
      _nextPercentage == 0 ? '' : '${_nextPercentage.toInt()}',
      style: TextStyle(
          fontSize: 40, fontWeight: FontWeight.w800, color: Color.fromRGBO(26, 200, 146, 1)),
    );
  }

  progressView() {
    return CustomPaint(
      child: Center(
        child: _progressDone ? getDoneImage() : Container(),
      ),
      foregroundPainter: ProgressPainter(
          defaultCircleColor: Color.fromRGBO(300, 300, 300, 1),
          percentageCompletedCircleColor: Color.fromRGBO(26, 200, 146, 1),
          completedPercentage: _percentage,
          circleWidth: 50.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: color,
      body: Container(
        alignment: Alignment.center,
        child: _progressDone == true
            ? Padding(
          padding: EdgeInsets.only(top: HEIGHT * 0.37),
          child: Center(
            child: Column(
              children: <Widget>[
                statusIcon,
                confirmTitle,
                confirmSubtitle,
                Padding(
                  padding: EdgeInsets.only(
                      left: WIDHT * 0.025, top: HEIGHT * 0.05),
                  child: Components.smallButton(
                        () => GlobalMethods().removePages(context),
                    Components.largeText(
                      'Volver al menú',
                      color: Colors.black,
                    ),
                    height: HEIGHT * 0.067,
                  ),
                ),
              ],
            ),
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: HEIGHT * 0.271,
              width: WIDHT * 0.509,
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(30.0),
              child: progressView(),
            ),
            _percentage < 27
                ? Components.mediumText("Reservando tu cita")
                : _percentage < 60
                ? Components.mediumText("Con los mejores profesionales")
                : Components.mediumText(
                "En " + widget.appointment.business.name),
          ],
        ),
      ),
    );
  }

  @override
  correctInsert() {
    isAppointmentInsert = true;
    statusIcon =
        Icon(Icons.check_circle_outline, color: Colors.white, size: 150);
    confirmTitle = Components.mediumText("Cita confirmada.",);
    confirmSubtitle = Components.mediumText("Gracias por confiar en Reservalo",);
  }

  @override
  incorrectInsert() {
    statusIcon = Icon(Icons.close, color: Colors.white, size: 150);
    confirmTitle = Components.mediumText("No se ha podido confirmar la cita",);
    confirmSubtitle = Components.mediumText("Disculpe las molestias, por favor intentelo de nuevo",);
    isAppointmentInsert = false;
  }

  @override
  modifyMaxPercentage(double value) {
    setState(() {
      _maxPercentage = value;
    });
  }
}
