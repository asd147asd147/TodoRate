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
    final _biggerFont = const TextStyle(fontSize: 18.0);
    Widget _buildRow(Text text){
        return ListTile(
                title: text,
                );
    }
    Widget _buildSuggestions() {
        return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, i){
                if (i.isOdd) return Divider();

                final index = i~/2;
                if(index >= _suggestions.length) {
                    _suggestions.addAll([Text("hello"), Text("hi"), Text("Ni Hao")]);
                }
                return _buildRow(_suggestions[index]);
            });
    }
    @override
    Widget build(BuildContext context){
        return Scaffold(
                appBar: AppBar(
                        title: Text('Welcom to TodoList'),
                        ),
                        body: _buildSuggestions(),
                );
    }
}
