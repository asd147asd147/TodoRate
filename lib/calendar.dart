import 'package:flutter/material.dart';
import 'dart:math';
import 'package:table_calendar/table_calendar.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';
import './todo.dart';

class MainCalendar extends StatefulWidget {
    @override
    _MainCalendarState createState() => _MainCalendarState();
}

class _MainCalendarState extends State<MainCalendar> {
    late DayTodo _dayTodo;
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
                            margin: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: LiquidLinearProgressIndicator(
                                    value: 0, 
                                    valueColor: AlwaysStoppedAnimation(Color(0xFF1974DE)),
                                    backgroundColor: Colors.white, 
                                    borderColor: Color(0xFF1974DE),
                                    borderWidth: 1.0,
                                    borderRadius: 5.0,
                                    direction: Axis.vertical, 
                                    center: Text(
                                            date.day.toString(),
                                            style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration.underline,
                                            ),
                                    ),
                            ),
                    );
                },
                todayBuilder: (context, date, events) {
                    return Container(
                            margin: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: LiquidLinearProgressIndicator(
                                    value: _dayTodo.dayValue, 
                                    valueColor: AlwaysStoppedAnimation(Colors.pink),
                                    backgroundColor: Colors.white, 
                                    borderColor: Colors.red,
                                    borderWidth: 1.0,
                                    borderRadius: 5.0,
                                    direction: Axis.vertical, 
                                    center: Text(date.day.toString()),
                            ),
                    );
                },
                defaultBuilder: (context, date, _) {
                    return Container(
                            margin: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: LiquidLinearProgressIndicator(
                                    value: Random().nextInt(100)/100.0, 
                                    valueColor: AlwaysStoppedAnimation(Color(0xFF8EDFFF)),
                                    backgroundColor: Colors.white, 
                                    borderColor: Color(0xFF1974DE),
                                    borderWidth: 1.0,
                                    borderRadius: 5.0,
                                    direction: Axis.vertical, 
                                    center: Text(date.day.toString()),
                            ),
                    );
                },
        );
    }

    @override
    Widget build(BuildContext context) {
        _dayTodo = context.watch<DayTodo>();
        return buildTableCalendar();
    }
}

