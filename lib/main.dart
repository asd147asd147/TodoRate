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
    State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
    final _suggestions = <Text>[];
    bool _ischecked = true;
    final _biggerFont = const TextStyle(fontSize: 18.0);
    int _counter = 10;
    void _incrementCounter() {
        setState(() {
                _counter++;
                _addTodo();
        });
    }

    Widget _buildRow(){
        //TODO
        bool _ischecked = true;
        return CheckboxListTile(
                title: Text("example"),
                value: _ischecked,
                onChanged: (value) {
                    setState(() {
                        _ischecked = !_ischecked;
                    });
                },
                controlAffinity: ListTileControlAffinity.leading,
                );
    }
    
    Widget _addTodo() {
        return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _counter,
                itemBuilder: (context, i) {
                    if(i.isOdd) return Divider();
                    return _buildRow();
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
                        onPressed: _incrementCounter,
                        tooltip: 'Increment',
                        child: Icon(Icons.add),
                        ),
                );
    }
}
