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

    Widget _bodyListView() {
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
                            child: _itemSection(todoList.todos[i]),
                            key: Key(todoList.todos[i].key),
                    );
                });
    }

    Widget _itemSection(Todo todo) {
        return Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                        children: [
                            Expanded(
                                    child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                                Container(
                                                        padding: const EdgeInsets.only(bottom: 8),
                                                        child: Text(todo.name),
                                                ),
                                                SliderTheme(
                                                        data: SliderTheme.of(context).copyWith(
                                                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.0),
                                                            overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                                                        ),
                                                        child : Slider(
                                                                value: todo.rate,
                                                                max: 100,
                                                                divisions: 100,
                                                                label: todo.rate.round().toString(),
                                                                onChanged: (double value){
                                                                    setState(() {
                                                                        todo.rate = value;
                                                                    });
                                                                }
                                                        ),
                                                ),
                                            ],
                                    ),
                            ),
                        ],
                ),
        );
    }

    Widget _addTodoButton() { 
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
                body: _bodyListView(),
                floatingActionButton: _addTodoButton(),
        );
    }
}
