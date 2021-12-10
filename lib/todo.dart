import 'package:flutter/material.dart';

class TodoList {
    List<Todo> todos = [];
    int get length => todos.length;

    TodoList();

    void addItem(String name) {
        todos.add(new Todo(name));
    }

    void removeItem(int index) {
        todos.removeAt(index);
    }

    TodoList.fromJson(Map<String, dynamic> json) {
        if (json['todo'] != null) {
            todos = [];
            json['todo'].forEach((v) {
                todos.add(new Todo.fromJson(v));
            });
        }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.todos != null) {
            data['todo'] = this.todos.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Todo {
    String name = '';
    bool isChecked = false;
    String key = UniqueKey().toString();

    Todo(String this.name);

    Todo.fromJson(Map<String, dynamic> json) {
        name = json['name'];
        isChecked = json['isChecked'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['name'] = this.name;
        data['isChecked'] = this.isChecked;
        return data;
    }
}
