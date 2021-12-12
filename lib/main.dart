import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
                title: 'My Flutter Todo List',
                home: MainWindow(),
        );
    }
}

class MainWindow extends StatefulWidget {
    @override
    _MainWindowState createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {

    Widget _mainBodyView(){
        return _buildTableCalendar();
    }
    Widget _buildTableCalendar() {
        return TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2010,1,1),
                lastDay: DateTime.utc(2030,12,31),
                //onHeaderTapped: _onHeaderTapped,
                headerStyle: HeaderStyle(
                        headerMargin: EdgeInsets.only(left: 40, top: 10, right: 40, bottom: 10),
                        titleCentered: true,
                        formatButtonVisible: false,
                        leftChevronIcon: Icon(Icons.arrow_left),
                        rightChevronIcon: Icon(Icons.arrow_right),
                        titleTextStyle: const TextStyle(fontSize: 17.0),
                ),
                calendarStyle: CalendarStyle(
                        outsideDaysVisible: true,
                        weekendTextStyle: TextStyle().copyWith(color: Colors.red),
                        holidayTextStyle: TextStyle().copyWith(color: Colors.blue[800]),
                ),
                //locale: 'ko-KR',
                //events: _events,
                //holidays: _holidays,
                //availableCalendarFormats: _availableCalendarFormats,
                //calendarController: _calendarController,
                //builders: calendarBuilder(),
                /*onDaySelected: (date, events, holidays) {
                    _onDaySelected(date, events, holidays);
                    _animationController.forward(from: 0.0);
                },*/
                //onVisibleDaysChanged: _onVisibleDaysChanged,
                //onCalendarCreated: _onCalendarCreated,
                );
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
                appBar: AppBar(
                        title: Text('Welcome to TodoList'),
                ),
                body: _mainBodyView(),
        );
    }
}
