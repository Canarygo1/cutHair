import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:cuthair/data/remote/Api/http_api_remote_repository.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:cuthair/ui/Pages/bottom_navigation/menu.dart';
import 'package:cuthair/ui/Pages/confirm_animation/confirm_animation_presenter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../../data/local/db_sqlite.dart';
import '../../../global_methods.dart';
import '../bottom_navigation/menu.dart';
import './progress_painter.dart';
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
  ApiRemoteRepository _apiRemoteRepository;
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
    _apiRemoteRepository = HttpApiRemoteRepository(Client());
    _presenter = ConfirmAnimationPresenter(
        this, _remoteRepository, _apiRemoteRepository);
    _presenter.init(widget.appointment);
    isAppointmentInsert = false;
    startProgress();
    initAnimationController();
  }

  initAnimationController() {
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
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
        isAppointmentInsert == true ? color = Colors.green : color = Colors.red;
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
    _nextPercentage += 1;
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
          fontSize: 40, fontWeight: FontWeight.w800, color: Colors.green),
    );
  }

  progressView() {
    return CustomPaint(
      child: Center(
        child: _progressDone ? getDoneImage() : Container(),
      ),
      foregroundPainter: ProgressPainter(
          defaultCircleColor: Color.fromRGBO(300, 300, 300, 1),
          percentageCompletedCircleColor: Colors.green,
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
                        child: MyButton(
                          () => GlobalMethods().pushAndReplacement(
                              context, Menu(DBProvider.users[0])),
                          LargeText(
                            'Volver al menu',
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
                      ? MediumText("Reservando tu cita")
                      : _percentage < 60
                          ? MediumText("Con los mejores profesionales")
                          : MediumText(
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
    confirmTitle = MediumText("Cita confirmada.",);
    confirmSubtitle = MediumText("Gracias por confiar en Reservalo",);
  }

  @override
  incorrectInsert() {
    statusIcon = Icon(Icons.close, color: Colors.white, size: 150);
    confirmTitle = MediumText("No se ha podido confirmar la cita",);
    confirmSubtitle = MediumText("Disculpe las molestias, por favor intentelo de nuevo",);
    isAppointmentInsert = false;
  }
}
