import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/views/HomeScreen.dart';
import 'package:todo/views/addTask.dart';


class calenderScreen extends StatefulWidget {
  @override
  _calenderscr createState() => _calenderscr();
}

class _calenderscr extends State<calenderScreen> {
  get calendarController => null;

  @override
  Widget build(BuildContext context) {
    return Content();
  }

  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay){
    setState(() {
      today = day;
    });
  }


  Widget Content(){
    return Scaffold(
      appBar: AppBar(
        title: Text("Calender"),
      ),
      body: Column(
        children: [
        // Text("Calender"),
        Container(
          child: TableCalendar(
            locale: "en_US",
            rowHeight: 60,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            availableGestures: AvailableGestures.all,
            selectedDayPredicate: (day) => isSameDay(day, today),
            focusedDay: today,
            firstDay: DateTime.utc(2010, 10, 10),
            lastDay: DateTime.utc(2030, 10, 10),
            onDaySelected: _onDaySelected,
          ),
        ),
      ],
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => myHomeScreen()));
              },
              child: Image(
                image: AssetImage("assets/Images/list.png"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddTaskForm()));
              },
              child: Image(
                image: AssetImage("assets/Images/plus-circle.png"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => calenderScreen()));
              },
              child: Image(
                image: AssetImage("assets/Images/calendar-days.png"),
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
