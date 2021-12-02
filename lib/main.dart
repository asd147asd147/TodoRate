import 'package:flutter/material.dart';

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


    List<Map> Todos = [];
    final _biggerFont = const TextStyle(fontSize: 18.0);

    Widget _buildRow(final todo){
            return CheckboxListTile(
                    title: Text(todo["name"]),
                    value: todo["isChecked"],
                    onChanged: (value) {
                        setState(() {
                            todo["isChecked"] = value;
                        });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    );
    }
    
    Widget _addTodo() {
        return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: Todos.length,
                itemBuilder: (context, i) {
                    return _buildRow(Todos[i]);
                });
    }
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
                            setState(() {Todos.add({"name" : name, "isChecked": false});});
                        },
                        tooltip: 'Increment',
                        child: Icon(Icons.add),
                        ),
                );
    }
    
    Future<String?> openDialog() => showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
                    title: Text('New Todo'),
                    content: TextField(
                            autofocus: true,
                            decoration: InputDecoration(hintText: 'Enter your todo'),
                            controller: controller,
                            ),
                    actions: [
                        TextButton(
                                child: Text('OK'),
                                onPressed: submit,
                                ),
                    ],
                    ),
            );
    void submit() {
        Navigator.of(context).pop(controller.text);
        controller.clear();
    }
}
