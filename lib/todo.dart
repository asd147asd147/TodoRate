import 'package:flutter/material.dart';

class Todos {
  List<Todo> todo = [];

  Todos();
  Todos.fromJson(Map<String, dynamic> json) {
    if (json['todo'] != null) {
      todo = [];
      json['todo'].forEach((v) {
        todo.add(new Todo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.todo != null) {
      data['todo'] = this.todo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Todo {
  String name = '';
  bool isChecked = false;

  Todo({required String this.name});

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
