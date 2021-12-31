import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class TodoFileIO {
    Future<String> get _localPath async {
        final directory = await getApplicationDocumentsDirectory();

        return directory.path;
    }

    Future<File> get _localFile async {
        final path = await _localPath;
        print('Save Path : $path');
        return File('$path/todoList.txt');
    }

    Future<File> writeCounter(json) async {
        final file = await _localFile;

        return file.writeAsString('$json');
    }

}

class AllTodo with ChangeNotifier {
    Map<String, DayTodo> dayTodoMap = {
        DateTime.utc(2022,1,1).toString() : DayTodo(categoryList: generateCategory(1), date: DateTime.utc(2022,1,1)),
        DateTime.utc(2022,1,2).toString() : DayTodo(categoryList: generateCategory(2), date: DateTime.utc(2022,1,2)),
    };

    void changeTodo(String date) {
        DayTodo _dayTodo = dayTodoMap[date]!;
        _dayTodo.categoryList.forEach((category) {
            category.itemList.forEach((item) {
                category.categoryValue += item.itemValue;
            });
            if(category.itemList.length != 0)
                category.categoryValue /= category.itemList.length * 100;
            else
                category.categoryValue = 0;
        });

        int categoryCount = 0;
        _dayTodo.dayValue = 0;
        _dayTodo.categoryList.forEach((category) {
            _dayTodo.dayValue += category.categoryValue;
            if(category.itemList.length != 0)
                categoryCount++;
        });

        if(categoryCount != 0)
            _dayTodo.dayValue /= categoryCount;

        notifyListeners();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if(this.dayTodoMap != null) {
            for(var v in this.dayTodoMap.entries) {
                data[v.key] = v.value.toJson();
            }
        }
        return data;
    }
}

class DayTodo with ChangeNotifier{
    DayTodo({
        required this.categoryList,
        required this.date,
        this.dayValue = 0,
    });

    void changeDayValue() {
        this.categoryList.forEach((category) {
            category.itemList.forEach((item) {
                category.categoryValue += item.itemValue;
            });
            if(category.itemList.length != 0)
                category.categoryValue /= category.itemList.length * 100;
            else
                category.categoryValue = 0;
        });

        int categoryCount = 0;
        this.dayValue = 0;
        this.categoryList.forEach((category) {
            this.dayValue += category.categoryValue;
            if(category.itemList.length != 0)
                categoryCount++;
        });

        if(categoryCount != 0)
            this.dayValue /= categoryCount;

        notifyListeners();
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = this.date;
        data['dayValue'] = this.dayValue;
        if(this.categoryList != null) {
            data['categoryList'] = this.categoryList.map((v) => v.toJson()).toList();
        }
        return data;
    }

    List<Category> categoryList;
    DateTime date;
    double dayValue;
}

class Category {
    Category({
        required this.headerValue,
        required this.itemList,
        this.categoryValue = 0,
        this.isExpanded = false,
    });

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['headerValue'] = this.headerValue;
        data['categoryValue'] = this.categoryValue;
        data['isExpanded'] = this.isExpanded;
        if (this.itemList != null) {
            data['itemList'] = this.itemList.map((v) => v.toJson()).toList();
        }
        return data;
    }

    String headerValue;
    double categoryValue;
    bool isExpanded;
    List<Item> itemList;
}

class Item {
    Item({
        required this.todoTitle,
        this.itemValue = 0,
        this.isEditingTitle = false,
    });

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['todoTitle'] = this.todoTitle;
        data['itemValue'] = this.itemValue;
        return data;
    }

    String todoTitle;
    double itemValue;
    bool isEditingTitle;
}

List<Category> generateCategory(int numberOfCategory) {
    return List<Category>.generate(numberOfCategory, (int index) {
        return Category(
            headerValue: 'Category $index',
            itemList: generateItems(2),
        );
    });
}

List<Item> generateItems(int numberOfItems) {
    return List<Item>.generate(numberOfItems, (int index) {
        return Item(
                todoTitle: 'This is todo number $index',
        );
    });
}

