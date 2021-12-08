import 'package:flutter/material.dart';
import './todo.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'My Flutter Todo List',
            home: TodoList(),
        );
    }
}

class TodoList extends StatefulWidget {
    @override
    _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
    late TextEditingController controller;

    @override
    void initState(){
        super.initState();

        controller = TextEditingController();
    }
    @override
    void dispose() {
        controller.dispose();

        super.dispose();
    }


    Todos todos = new Todos();

    Widget _buildRow(final todo){
            return CheckboxListTile(
                    title: Text(todo.name),
                    value: todo.isChecked,
                    onChanged: (value) {
                        setState(() {
                            todo.isChecked = value;
                        });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    );
    }
    
    Widget _addTodo() {
        return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: todos.todo.length,
                itemBuilder: (context, i) {
                    final todo = todos.todo[i];
                    return Dismissible(
                            background: Container(color : Colors.red,),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction){
                                setState(() {
                                    if(direction == DismissDirection.startToEnd){
                                        todos.todo.removeAt(i);
                                    }
                                });
                            },
                            child: _buildRow(todo),
                            key: Key(todo.name),
                            );
                });
    }
    
    String _selectedDate = 'Select Date';
    @override
    Widget build(BuildContext context){
        return Scaffold(
                appBar: AppBar(
                        title: Text('Welcom to TodoList'),
                        ),
                body: _addTodo(),
                floatingActionButton: FloatingActionButton(
                        onPressed: () async {
                            final name = await openDialog();
                            if (name == null || name.isEmpty) return;
                            setState(() {
                                todos.todo.add(Todo(name: name));
                                print(todos.toJson());
                            });
                        },
                        tooltip: 'Increment',
                        child: Icon(Icons.add),
                        ),
                );
    }
    
    Future<String?> openDialog() => showDialog<String>(
            context: context,
            builder: (context) {
                return StatefulBuilder(
                        builder: (context, setState){
                            return AlertDialog(
                                    title: Text('New Todo'),
                                    content: SingleChildScrollView(
                                            child: ListBody(
                                                    children: [
                                                        TextField(
                                                                autofocus: true,
                                                                decoration: InputDecoration(hintText: 'Enter your todo'),
                                                                controller: controller,
                                                        ),
                                                        RaisedButton(
                                                                child: Text('$_selectedDate'),
                                                                onPressed: () {
                                                                    Future<DateTime?> future = showDatePicker(
                                                                            context: context,
                                                                            initialDate: DateTime.now(),
                                                                            firstDate: DateTime(2018),
                                                                            lastDate: DateTime(2030),
                                                                            builder: (BuildContext coUAntext, Widget? child) {
                                                                                return Theme(
                                                                                        data: ThemeData.light(),
                                                                                        child: child!,
                                                                                );
                                                                            },
                                                                    );

                                                                future.then((date) {
                                                                    if(date != null){
                                                                        setState(() {
                                                                            _selectedDate = date.toString().substring(0,10);
                                                                        });
                                                                    }
                                                                });
                                                        }),
                                                    ],
                                                ), 
                                            ),
                                            actions: [
                                                TextButton(
                                                    child: Text('OK'),
                                                    onPressed: submit,
                                                ),
                                            ],
                                    );
                        },
                );
            },
    );
    void submit() {
        Navigator.of(context).pop(controller.text);
        controller.clear();
    }
}
