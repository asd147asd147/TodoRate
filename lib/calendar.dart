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
    late AllTodo allTodo;
    late Map<String, DayTodo> dayTodoMap;
    late CategoryList categoryList;
    CalendarFormat _calendarFormat = CalendarFormat.month;
    late DateTime _focusedDay;
    DateTime? _selectedDay;

    Color primaryBorder = Color(0xFF151026);
    Color defaultColor = Colors.indigo;

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
                            allTodo.setFocusedDay(_focusedDay);
                        });
                    }
                },
                onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                        setState(() {
                            //_calendarFormat = format;
                        });
                    }
                },
                onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                },
                //locale: 'ko-KR',
                calendarBuilders: calendarBuilder(),
        );
    }

    CalendarBuilders calendarBuilder() {
        return CalendarBuilders(
                selectedBuilder: (context, date, _) {
                    if(dayTodoMap[date.toString().substring(0,10)] == null){
                        allTodo.addDayTodo(date);
                    }
                    return Container(
                            margin: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: LiquidLinearProgressIndicator(
                                    value: dayTodoMap[date.toString().substring(0,10)]!.dayValue, 
                                    valueColor: AlwaysStoppedAnimation(Color(0xFFE81364)),
                                    backgroundColor: Colors.white, 
                                    borderColor: Colors.red,
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
                    Color? _borderColor;
                    Animation<Color>? _valueColor;
                    if(_selectedDay == null) {
                        _selectedDay = date;
                        _borderColor = Colors.red;
                        _valueColor = AlwaysStoppedAnimation(Color(0xAAE91E63));
                    }
                    else {
                        _borderColor = primaryBorder; 
                        _valueColor = AlwaysStoppedAnimation(defaultColor);
                    }
                    
                    return Container(
                            margin: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: LiquidLinearProgressIndicator(
                                    value: dayTodoMap[date.toString().substring(0,10)]!.dayValue, 
                                    valueColor: _valueColor,
                                    backgroundColor: Colors.white, 
                                    borderColor: _borderColor, 
                                    borderWidth: 1.0,
                                    borderRadius: 5.0,
                                    direction: Axis.vertical, 
                                    center: Text(
                                            date.day.toString(),
                                            style: TextStyle(color: Color(0xFF151026)),
                                    ),
                            ),
                    );
                },
                defaultBuilder: (context, date, _) {
                    if(dayTodoMap[date.toString().substring(0,10)] == null){
                        allTodo.addDayTodo(date);
                    }
                    return Container(
                            margin: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: LiquidLinearProgressIndicator(
                                    value: dayTodoMap[date.toString().substring(0,10)]!.dayValue, 
                                    valueColor: AlwaysStoppedAnimation(defaultColor),
                                    backgroundColor: Colors.white, 
                                    borderColor: primaryBorder,
                                    borderWidth: 1.0,
                                    borderRadius: 5.0,
                                    direction: Axis.vertical, 
                                    center: Text(
                                            date.day.toString(),
                                            style: TextStyle(color: Color(0xFF151026)),
                                    ),
                            ),
                    );
                },
        );
    }

    @override
    Widget build(BuildContext context) {
        allTodo = context.watch<AllTodo>();
        dayTodoMap = allTodo.dayTodoMap;
        _focusedDay = allTodo.rawFocusedDay;
        return buildTableCalendar();
    }
}

