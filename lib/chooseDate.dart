import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'globalMethods.dart';
import 'homePage.dart';

class chooseDateScreen extends StatefulWidget {

  @override
  _chooseDateScreenState createState() => _chooseDateScreenState();
}

class _chooseDateScreenState extends State<chooseDateScreen> {

  Widget goBack(BuildContext context){
    return Container(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 350.0, 0.0),
        child: GestureDetector(
          onTap: (){
            globalMethods().pushPage(context, home());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.navigate_before,
                color: Colors.white,
                size: 35.0,
              ),
            ],
          ),
        )
    );
  }

  DateTime _currentDate = new DateTime.now();
  DateTime _currentDate2;
  DateTime _finalDate;
  List<String> _freeHour = ["10:30", "11:00", "11:30", "15:00", "15:45", "17:00"];

  EventList<Event> _markedDateMap = new EventList<Event>();

  Widget textHour(){
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
      child: Text(
        "Horas disponibles",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget calendar(){
    return Container(
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() => _currentDate2 = date);
        },
        weekendTextStyle: TextStyle(
          color: Colors.red,
        ),
        headerTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23.0,
        ),
        showHeaderButton: false,
        showOnlyCurrentMonthDate: false,
        weekFormat: false,
        markedDatesMap: _markedDateMap,
        height: 400.0,
        selectedDateTime: _currentDate2,
        customGridViewPhysics: NeverScrollableScrollPhysics(),
        markedDateCustomShapeBorder: CircleBorder(
            side: BorderSide(color: Colors.white)
        ),
        markedDateCustomTextStyle: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
        todayTextStyle: TextStyle(
          color: Colors.white,
        ),
        todayButtonColor: Colors.red,
        selectedDayTextStyle: TextStyle(
          color: Colors.white,
        ),
        daysTextStyle: TextStyle(
          color: Colors.white,
        ),
        prevDaysTextStyle: TextStyle(
          color: Colors.transparent,
        ),

        customDayBuilder: (   /// you can provide your own build function to make custom day containers
            bool isSelectable,
            int index,
            bool isSelectedDay,
            bool isToday,
            bool isPrevMonthDay,
            TextStyle textStyle,
            bool isNextMonthDay,
            bool isThisMonthDay,
            DateTime day,
            ) {
          _finalDate = null;
          if (day == _currentDate2 && day.isAfter(_currentDate)) {
            _finalDate = day;
            return Center(
              child: Icon(Icons.content_cut),
            );
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget buttonsHour(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.60,
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(_freeHour.length, (index) {
            return Center(
              child: ButtonTheme(
                child: RaisedButton(
                  child: Text(
                    _freeHour.elementAt(index),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  onPressed: () {
                    if(_finalDate != null) {
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                ),

                buttonColor: Color.fromRGBO(230, 73, 90, 1),
          ),
            );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromRGBO(300, 300, 300, 1),
        child: ListView(
          children: <Widget>[
            goBack(context),
            calendar(),
            textHour(),
            buttonsHour(context),
          ],
        ),
      ),
    );
  }
}


