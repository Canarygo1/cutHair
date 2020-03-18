import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:flutter/material.dart';

class ClienteHome extends StatefulWidget {
  @override
  _ClienteHomeState createState() => _ClienteHomeState();
}

class _ClienteHomeState extends State<ClienteHome> {
  List<Appointment> appoiments = [];
  globalMethods global = globalMethods();

  @override
  Widget build(BuildContext context) {
    global.context = context;
    return new WillPopScope(
        onWillPop: global.onWillPop,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(300, 300, 300, 1)),
            child: ListView(
              children: <Widget>[topTitle(), myAppoiment()],
            ),
          ),
        ));
  }

  Widget topTitle() {
    return Container(
        height: 90,
        padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(230, 73, 90, 1),
        ),
        child: Text(
          'Mis citas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ));
  }

  Widget myAppoiment() => Container(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20.0),
        height: MediaQuery.of(context).size.height * 0.90,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: appoiments.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: ListTile(
                  dense: true,
                  title: Text('Tipo de servicio: ' +
                      appoiments.elementAt(index).service.tipo),
                  subtitle: ListView(
                    children: <Widget>[
                      Text('Fecha del servicio: ' +
                          appoiments[index].checkIn.day.toString() +
                          '/' +
                          appoiments[index].checkIn.month.toString() +
                          '/' +
                          appoiments[index].checkIn.year.toString()),
                      Text('Hora del servicio' +
                          appoiments[index].checkIn.hour.toString() +
                          ':' +
                          appoiments[index].checkIn.minute.toString()),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {});
                    },
                    child: Container(
                      child: Icon(
                        Icons.restore_from_trash,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),
      );
}
