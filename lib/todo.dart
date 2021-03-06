import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class TodoFileIO {
    String fileName = '';
    TodoFileIO(this.fileName);

    Future<String> get _localPath async {
        final directory = await getApplicationDocumentsDirectory();

        return directory.path;
    }

    Future<File> get _localFile async {
        final path = await _localPath;
        return File('$path/$fileName');
    }

    Future<File> writeJson(json) async {
        final file = await _localFile;

        print('Save Path : $file');
        return file.writeAsString('$json');
    }

    Future<String> readJson() async {
        try {
            final file = await _localFile;

            print('Read Path : $file');
            String json = await file.readAsString();
            return json;
        } catch (e) {
            this.writeJson('');
            return '';
        }
    }

}

class CategoryList {
    TodoFileIO fileIO = TodoFileIO('categoryList.txt');
    List<CategoryUnit> items = [];
    int get length => items.length;
    
    CategoryList() {
        fileIO.readJson().then((String jsonString) {
            if(jsonString == '') {
                fileIO.writeJson(jsonEncode(this.toJson()));
            }
            else {
                this.fromJson(jsonDecode(jsonString));
            }
        });
    }

    void changeCategory() {
        fileIO.writeJson(jsonEncode(this.toJson()));
    }

    void addItem(String title) {
        items.add(CategoryUnit(title));
    }

    void fromJson(Map<String, dynamic> json) {
        this.items = <CategoryUnit>[];
        json['items'].forEach((v) {
            items.add(new CategoryUnit.fromJson(v));
        });
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['items'] = this.items.map((v) => v.toJson()).toList();
        return data;
    }
}

class CategoryUnit {
    String categoryTitle = '';
    bool isEditingTitle = false;
    
    CategoryUnit(this.categoryTitle);

    CategoryUnit.fromJson(Map<String, dynamic> json):
        categoryTitle = json['categoryTitle']
    {}

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['categoryTitle'] = this.categoryTitle;
        return data;
    }
}

class AllTodo with ChangeNotifier {
    Map<String, DayTodo> dayTodoMap = {};
    DateTime _focusedDay = DateTime.now();
    DateTime get rawFocusedDay => _focusedDay;
    String get focusedDay => _focusedDay.toString().substring(0,10);
    TodoFileIO fileIO = TodoFileIO('todoList.txt');
    CategoryList categoryList = CategoryList();

    AllTodo() {
        fileIO.readJson().then((String jsonString){
            if(jsonString != '') this.fromJson(jsonDecode(jsonString));
        });
        if(this.dayTodoMap[focusedDay] == null) {
            addDayTodo(rawFocusedDay);
        }
    }

    void changeItemList(int oldIndex, int newIndex, int categoryIndex) {
        for(var v in this.dayTodoMap.values) {

        }

    }

    void editCategory(String newValue, int index) {
        for(var v in this.dayTodoMap.values) {
            v.categoryList[index].headerValue = newValue;
        }
        categoryList.changeCategory();
        fileIO.writeJson(jsonEncode(this.toJson()));
        notifyListeners();
    }

    void changeIndex(int oldIndex, int newIndex) {
        for(var v in this.dayTodoMap.values) {
            final Category category = v.categoryList.removeAt(oldIndex);
            v.categoryList.insert(newIndex, category);
        }
        categoryList.changeCategory();
        fileIO.writeJson(jsonEncode(this.toJson()));
        notifyListeners();
    }

    void addCategory(String title) {
        categoryList.addItem(title);
        for(var v in this.dayTodoMap.values) {
            v.categoryList.add(Category(
                            headerValue: title,
                            itemList: generateItems(0),
            ));
        }
        categoryList.changeCategory();
        fileIO.writeJson(jsonEncode(this.toJson()));
        notifyListeners();
    }

    void removeCategory(int index) {
        for(var v in this.dayTodoMap.values) {
            v.categoryList.removeAt(index);
        }
        categoryList.changeCategory();
        fileIO.writeJson(jsonEncode(this.toJson()));
        notifyListeners();
    }

    void addDayTodo(DateTime date) {
        dayTodoMap[date.toString().substring(0,10)] = DayTodo(categoryList: generateCategory(categoryList.items, categoryList.length), date: date);
    }
    
    void setFocusedDay(DateTime date) {
        _focusedDay = date;
        notifyListeners();
    }
    
    void changeCategory() {
        categoryList.changeCategory();
        fileIO.writeJson(jsonEncode(this.toJson()));
        notifyListeners();
    }

    void changeTodo() {
        DayTodo _dayTodo = dayTodoMap[focusedDay]!;
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

        fileIO.writeJson(jsonEncode(this.toJson()));
        notifyListeners();
    }

    void fromJson(Map<String, dynamic> json) {
        dayTodoMap = new Map<String, DayTodo>();
        for(var v in json.entries) {
            dayTodoMap[v.key] = new DayTodo.fromJson(v.value);
        }
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

    DayTodo.fromJson(Map<String, dynamic> json):
        categoryList = <Category>[],
        date = DateTime.parse(json['date']),
        dayValue = json['dayValue'] as double
    {
        json['categoryList'].forEach((v) {
            categoryList.add(new Category.fromJson(v));
        });
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = this.date.toString();
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

    Category.fromJson(Map<String, dynamic> json):
        headerValue = json['headerValue'],
        itemList = <Item>[],
        categoryValue = json['categoryValue'],
        isExpanded = json['isExpanded']
    {
        json['itemList'].forEach((v) {
            itemList.add(new Item.fromJson(v));
        });
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['headerValue'] = this.headerValue;
        data['categoryValue'] = this.categoryValue;
        data['isExpanded'] = false;
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

    Item.fromJson(Map<String, dynamic> json):
        todoTitle = json['todoTitle'],
        itemValue = json['itemValue'],
        isEditingTitle = false
    {}

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

List<Category> generateCategory(List<CategoryUnit> categoryList, int numberOfCategory) {
    return List<Category>.generate(numberOfCategory, (int index) {
        return Category(
            headerValue: categoryList[index].categoryTitle,
            itemList: generateItems(0),
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

