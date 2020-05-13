import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class CalendarWidget extends StatefulWidget {
  Function press;
  DateTime currentDate2;
  DateTime currentDate = DateTime.now();
  CalendarWidget(this.press, {this.currentDate2});

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget>{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.57,
      child: CalendarCarousel<Event>(
        onDayPressed: widget.press,
        weekendTextStyle: TextStyle(
          color: Colors.white,
        ),
        firstDayOfWeek: 1,
        locale: "es",
        headerTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23.0,
        ),
        showHeaderButton: false,
        showOnlyCurrentMonthDate: true,
        weekFormat: false,
        height: 400.0,
        selectedDateTime: widget.currentDate2,
        customGridViewPhysics: NeverScrollableScrollPhysics(),
        todayTextStyle: TextStyle(
          color: Colors.white,
        ),
        selectedDayButtonColor: Color.fromRGBO(230, 73, 90, 1),
        todayButtonColor: Colors.green,
        daysTextStyle: TextStyle(
          color: Colors.white,
        ),
        prevDaysTextStyle: TextStyle(
          color: Colors.transparent,
        ),
      ),
    );
  }
}