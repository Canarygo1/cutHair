import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/schedule.dart';
import 'package:flutter/material.dart';


/*class ScheduleScreen extends StatefulWidget {
  List<Schedule> days = [];
  String name;
  String hairDressingUid;
  String typeBusiness;
  ScheduleScreen(this.days, this.name, this.hairDressingUid, this.typeBusiness);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState(this.days, this.name, this.hairDressingUid, this.typeBusiness);
}*/

/*class _ScheduleScreenState extends State<ScheduleScreen> {

  List<Schedule> days;
  String name;
  RemoteRepository _remoteRepository;
  String hairDressingUid;
  String typeBusiness;
  _ScheduleScreenState(this.days, this.name, this.hairDressingUid, this.typeBusiness);

  @override
  void initState() {
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20.0),
      height: MediaQuery.of(context).size.height * 0.90,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: this.widget.days.length,
          itemBuilder: (context, index) {
            return Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: days[index].ranges.length,
                  itemBuilder: (context, indexranges) {
                    return Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text(
                          days[index].uid.day.toString() +
                              "-" +
                              days[index].uid.month.toString() +
                              "-" +
                              days[index].uid.year.toString(),
                        ),
                        subtitle: Text('Hora de entrada: ' +
                            days[index].ranges[indexranges]["Entrada"] +
                            ":00" +
                            ' hora de salida: ' +
                            days[index].ranges[indexranges]["Salida"] +
                            ":00"),
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              removeSchedule(days[index].uid, this.name, this.widget.hairDressingUid, this.typeBusiness, days[index].ranges[indexranges]);
                              days[index].ranges.removeAt(indexranges);
                            });
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
          }),
    );
  }

  removeSchedule(DateTime day, String name, String hairDressingUid, String typeBusiness, Map ranges){
    _remoteRepository.removeRange(day, name, hairDressingUid, typeBusiness, ranges);
  }
}*/
