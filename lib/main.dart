import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'package:provider/provider.dart';
import 'dart:convert';
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
    Widget mainListView = MainListView();
    List<String> drawerList = ['Daily', 'Study','Other'];

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
                               drawer: Drawer(
                                       child: SingleChildScrollView(
                                               child: Column(
                                               children: [
                                                   ListView.builder(
                                                           padding: EdgeInsets.zero,
                                                           shrinkWrap: true,
                                                           itemCount: drawerList.length+1,
                                                           itemBuilder: (BuildContext context, int index) {
                                                               if(index == 0){
                                                                   return const DrawerHeader(
                                                                           decoration: BoxDecoration(
                                                                                   color: Colors.blue,
                                                                           ),
                                                                           child: Text('Drawer Header'),
                                                                   );
                                                               }
                                                               return ListTile(
                                                                       title: Text(drawerList[index-1]),
                                                                       trailing: IconButton(
                                                                               onPressed: () {
                                                                                   setState(() {
                                                                                       drawerList.removeWhere((String currentDrawer) => drawerList[index-1] == currentDrawer);
                                                                                   });
                                                                               },
                                                                               icon: Icon(Icons.delete),
                                                                       ),
                                                               );
                                                           }),
                                                           Container(
                                                                   padding: const EdgeInsets.only(bottom: 10.0),
                                                           child: Column(
                                                                   children: [
                                                                       Divider(),
                                                                       Center(
                                                                               child: ElevatedButton.icon(
                                                                                       icon: Icon(Icons.add),
                                                                                       label: Text('Add'),
                                                                                       onPressed: () {
                                                                                           setState(() {
                                                                                                drawerList.add('Test');
                                                                                           });
                                                                                       },
                                                                               ),
                                                                       ),
                                                                   ],
                                                           ),
                                                   ),
                                                   ],
                                                   ),
                                       ),
                               ),
                               appBar: AppBar(
                                title: Text('TodoRate'),
                        ),
                        body: _mainBodyView(),
                ),
        );
    }
}
