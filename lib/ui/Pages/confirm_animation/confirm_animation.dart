import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/Components/large_text.dart';
import 'package:cuthair/ui/Components/medium_text.dart';
import 'package:cuthair/ui/Pages/bottom_navigation/menu.dart';
import 'package:flutter/material.dart';
import './progress_painter.dart';
import 'dart:ui';
import 'dart:async';

class ConfirmAnimation extends StatefulWidget {
  ConfirmAnimation() : super();

  final String title = "Custom Paint Demo";

  @override
  ConfirmAnimationState createState() => ConfirmAnimationState();
}

class ConfirmAnimationState extends State<ConfirmAnimation>
    with SingleTickerProviderStateMixin {
  double _percentage;
  double _nextPercentage;
  Timer _timer;
  AnimationController _progressAnimationController;
  bool _progressDone;
  Color color = Color.fromRGBO(300, 300, 300, 1);
  List<User> lista;
  Widget screen;

  @override
  initState() {
    super.initState();
    _percentage = 0.0;
    _nextPercentage = 0.0;
    _timer = null;
    _progressDone = false;
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
        color = Colors.green;
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
    setState(() {
      _percentage = _nextPercentage;
      _nextPercentage += 1;
      if (_nextPercentage > 100.0) {
        _percentage = 0.0;
        _nextPercentage = 0.0;
      }
      _progressAnimationController.forward(from: 0.0);
    });
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
    return Scaffold(
      backgroundColor: color,
      body: Container(
        alignment: Alignment.center,
        child: _progressDone == true
            ? Padding(
              padding: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.37),
              child: Center(
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 150),
                      MediumText(
                        "Cita confirmada.",
                      ),
                      MediumText("Gracias por confiar en Reservalo"),
                      Padding(
                        padding: EdgeInsets.only(left: 10,top: MediaQuery.of(context).size.height * 0.05),
                        child: ButtonTheme(
                          child: RaisedButton(
                            child: Text('Volver al menu' ),
                            onPressed: () async {
                              await DBProvider.db.getUser();
                              if (DBProvider.users.length > 0) lista = DBProvider.users;
                              if (lista != null) {
                                screen = Menu(lista[0]);
                              }
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Menu(lista[0])));

                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                          ),
                          height: 60.0,
                          minWidth: 150,
                          buttonColor: Colors.white,
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
                    height: 200.0,
                    width: 200.0,
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.all(30.0),
                    child: progressView(),
                  ),
                  _percentage < 27
                      ?
                  MediumText("Reservando tu cita")
                      :
                  _percentage < 60
                      ?
                  MediumText("Con los mejores profesionales")
                      :
                  MediumText("En Privilege")
                  ,
                ],
              ),
      ),
    );
  }
}
