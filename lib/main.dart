import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'package:provider/provider.dart';
import './calendar.dart';
import './mainListView.dart';
import './todo.dart';

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
                title: 'My Flutter Todo List',
                localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
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
    Widget mainCalendar = MainCalendar();

    Widget _mainBodyView() {
        Widget mainListView = MainListView();
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
        TodoFileIO fileIO = TodoFileIO();
        AllTodo allTodo = context.watch<AllTodo>();
        fileIO.writeJson(allTodo.toJson());
        return GestureDetector(
                onTap: () {
                    FocusScope.of(context).unfocus();
                },
                child: Scaffold(
                        appBar: AppBar(
                                title: Text('Welcome to TodoList'),
                        ),
                        body: _mainBodyView(),
                ),
        );
    }
}
