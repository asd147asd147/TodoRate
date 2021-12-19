import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 
import './calendar.dart';
import './mainListView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
                title: 'My Flutter Todo List',
                localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                    const Locale('ko', 'KR'),
                ],
                home: MainWindow(),
        );
    }
}

class MainWindow extends StatefulWidget {
    @override
    _MainWindowState createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
<<<<<<< HEAD
    MainCalendar mainCalendar = MainCalendar();
=======

    Widget mainCalendar = MainCalendar();
    Widget mainListView = MainListView();

>>>>>>> 8a3fa2c (Add expansion listview in main window, but not working expansion panel)
    Widget _mainBodyView(){
        return SingleChildScrollView(
                child: Column(
                        children: [
                            mainCalendar,
                            mainListView,
                        ],),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
                appBar: AppBar(
                        title: Text('Welcome to TodoList'),
                ),
                body: _mainBodyView(),
        );
    }
}
