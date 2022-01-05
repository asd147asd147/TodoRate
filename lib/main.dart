import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'package:provider/provider.dart';
import 'dart:convert';
import './calendar.dart';
import './mainListView.dart';
import './todo.dart';
import './drawer.dart';

void main() {
    runApp(
            MultiProvider(
                    providers:[
                        ChangeNotifierProvider(create: (_) => AllTodo()),
                    ],
                    child: MyApp(),
            ),
    );
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
                title: 'TodoRate',
                localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                    const Locale('ko', 'KR'),
                ],
                debugShowCheckedModeBanner: false,
                home: MainWindow(),
        );
    }
}

class MainWindow extends StatefulWidget {
    @override
    _MainWindowState createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
    Widget mainCalendar = MainCalendar();
    Widget mainListView = MainListView();
    Widget drawerView = DrawerView();

    Widget _mainBodyView() {
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
        return GestureDetector(
                onTap: () {
                    FocusScope.of(context).unfocus();
                },
                child: Scaffold(
                               drawer: drawerView,
                               appBar: AppBar(
                                       title: Text('TodoRate'),
                                       flexibleSpace: Container(
                                               decoration: BoxDecoration(
                                                       gradient: LinearGradient(
                                                               begin: Alignment.topLeft,
                                                               end: Alignment.bottomRight,
                                                               colors: <Color>[
                                                                   Color(0xFF151026),
                                                                   Colors.indigo,
                                                               ],
                                                       ),
                                               ),
                                       ),
                               ),
                               body: _mainBodyView(),
                       ),
        );
    }
}
