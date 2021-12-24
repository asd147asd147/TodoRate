import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatefulWidget {
    @override
    _MainCalendarState createState() => _MainCalendarState();
}

class _MainCalendarState extends State<MainCalendar> {
    CalendarFormat _calendarFormat = CalendarFormat.month;
    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;

    Widget buildTableCalendar() {
        return TableCalendar(
                firstDay: DateTime.utc(2010,1,1),
                lastDay: DateTime.utc(2030,12,31),
                focusedDay: _focusedDay,
                //onHeaderTapped: _onHeaderTapped,
                headerStyle: HeaderStyle(
                        headerMargin: EdgeInsets.only(left: 40, top: 10, right: 40, bottom: 10),
                        titleCentered: true,
                        formatButtonVisible: false,
                        leftChevronIcon: Icon(Icons.arrow_left),
                        rightChevronIcon: Icon(Icons.arrow_right),
                        titleTextStyle: const TextStyle(fontSize: 17.0),
                ),
                calendarFormat: _calendarFormat,
                calendarStyle: CalendarStyle(
                        outsideDaysVisible: false,
                ),
                selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                        });
                    }
                },
                onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                        setState(() {
                            _calendarFormat = format;
                        });
                    }
                },
                onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                },
                locale: 'ko-KR',
                //events: _events,
                //holidays: _holidays,
                //availableCalendarFormats: _availableCalendarFormats,
                //calendarController: _calendarController,
                calendarBuilders: calendarBuilder(),
                //onDaySelected: _onDaySelected,
                //onVisibleDaysChanged: _onVisibleDaysChanged,
                //onCalendarCreated: _onCalendarCreated,
        );
    }

    void _onDaySelected(DateTime day, DateTime e) {
        setState(() {
            _selectedDay = day;
        });
    }

    CalendarBuilders calendarBuilder() {
        return CalendarBuilders(
                selectedBuilder: (context, date, _) {
                    return Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.white),
                            ));
                },
                todayBuilder: (context, date, events) {
                    return Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.white),
                            ));
                },
                defaultBuilder: (context, date, _) {
                    return Container(
                            margin: const EdgeInsets.all(4.0),
                            padding: const EdgeInsets.only(top: 4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(

                            ),
                            child: Column(
                                    children: [
                                        Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius: BorderRadius.circular(2.0)),
                                        ),
                                        Text(
                                                date.day.toString(),
                                                style: TextStyle(color: Colors.black),
                                        ),
                                    ],
                            ));
                },
        );
    }

    @override
    Widget build(BuildContext context) {
        return buildTableCalendar();
    }
}

