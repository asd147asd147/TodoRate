import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllTodo with ChangeNotifier {
    late Map<String, DayTodo> dayTodoMap;

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
