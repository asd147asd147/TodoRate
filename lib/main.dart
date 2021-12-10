import 'package:flutter/material.dart';
import './todo.dart';

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
    TodoList todoList = new TodoList();

    Widget bodyListView() {
        return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: todoList.length,
                itemBuilder: (context, i){
                    return Dismissible(
                            background: Container(color : Colors.red,),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction){
                                if(direction == DismissDirection.startToEnd){
                                    setState((){
                                        todoList.removeItem(i);
                                    });
                                }
                            },
                            child: ListTile(
                                           title: Text(todoList.todos[i].name),
                                   ),
                            key: Key(todoList.todos[i].key),
                    );
                });
    }

    Widget addTodoButton() { 
        return FloatingActionButton(
                onPressed: () {
                    setState((){
                        todoList.addItem('Test merge pull request');
                    });
                },
                tooltip: 'Increment',
                child: Icon(Icons.add),
        );
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
                appBar: AppBar(
                        title: Text('Welcome to TodoList'),
                ),
                body: bodyListView(),
                floatingActionButton: addTodoButton(),
        );
    }
}
