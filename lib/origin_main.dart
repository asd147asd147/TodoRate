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
    late TextEditingController controller;
    TodoList todoList = new TodoList();
    bool _inputState = false;

    @override
    void initState(){
        super.initState();
        controller = TextEditingController();
    }
    @override
    void dispose(){
        controller.dispose();
        super.dispose();
    }

    Widget _bodyView() {
        return Container(
                margin: const EdgeInsets.only(left: 15, top: 50, right: 15, bottom: 50),
                decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                        ),
                        boxShadow: [
                            BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3)
                            ),
                        ],
                ),
                /*child: Column(
                        children: [
                            _todoHeader(),
                            _todoListView(),
                        ],
                ),*/
                        child: SingleChildScrollView(
                                child: ExpansionPanelList(
                                children : [ ExpansionPanel(
                                        headerBuilder: (BuildContext context, bool isExpanded) {
                                            return ListTile(
                                                    title: Text('Test ExapnsionPanel'),
                                            );
                                        },
                                        body: SingleChildScrollView(
                                                      child: _todoListView(),
                                              ),
                                        isExpanded: true,
                                ),
                                ],
                        ),
                        ),
                        );
    }

    Widget _todoHeader(){
        return  Row(
                children: [
                    Expanded(
                            child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),
                                            ),
                                    ),
                                    child: Text(
                                            '2021-12-31',
                                            style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                            ),
                                            textAlign: TextAlign.left,
                                    ),
                            ),
                    ),
                    ],
                    );
    }

    Widget _todoListView(){
        int len = todoList.length;
        if(_inputState) len++;
        return ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: len,
                        itemBuilder: (context, i){
                            if(_inputState && i == len-1){
                                return Container(
                                        padding: const EdgeInsets.all(10),
                                        child: TextField(
                                                autofocus: true,
                                                textInputAction: TextInputAction.go,
                                                onSubmitted: (String name) {
                                                    _inputState = false;
                                                    setState(() {
                                                        if(name != ''){
                                                            todoList.addItem(name);
                                                        }
                                                    });
                                                },
                                        ),
                                );
                            }
                            else{
                                return Dismissible(
                                        background: Container(color : Colors.red,),
                                        direction: DismissDirection.startToEnd,
                                        onDismissed: (direction){
                                            if(direction == DismissDirection.startToEnd){
                                                setState(() {
                                                    todoList.removeItem(i);
                                                });
                                            }
                                        },
                                        child: _todoView(todoList.todos[i]),
                                        key: Key(todoList.todos[i].key),
                                );
                            }
                        });
    }

    Widget _todoView(Todo todo) {
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
                    setState(() {
                        _inputState = true;
                    });
                },
                tooltip: 'Increment',
                child: Icon(Icons.add),
        );
    }

    @override
    Widget build(BuildContext context){
        return GestureDetector(
                onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if(!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                        _inputState = false;
                    }
                },
                child: Scaffold(
                               appBar: AppBar(
                                       title: Text('Welcome to TodoList'),
                               ),
                               body: _bodyView(),
                               floatingActionButton: _addTodoButton(),
                       ),
        );
    }
}
