import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 
import './calendar.dart';

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
    MainCalendar mainCalendar = MainCalendar();
    Widget _mainBodyView(){
        return mainCalendar;
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
