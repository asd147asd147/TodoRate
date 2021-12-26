import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 

class MainListView extends StatefulWidget {
    @override
    _MainListViewState createState() => _MainListViewState();
}

class DayTodo {
    DayTodo({
        required this.categoryList,
        this.dayValue = 0,
    });

    List<Category> categoryList;
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

class _MainListViewState extends State<MainListView> {
    late TextEditingController _editingController;
    late Item _editingItem;
    final focusNode = FocusNode();
    final DayTodo _dayTodo = DayTodo(categoryList: generateCategory(4));

    @override
    void initState() {
        super.initState();
        _editingController = TextEditingController(text: '');
        focusNode.addListener(() {
            if(!focusNode.hasFocus) {
                setState(() {
                    _editingItem.todoTitle = _editingController.text;
                    _editingItem.isEditingTitle = false;
                });
            }
        });
    }

    @override
    void dispose() {
        focusNode.dispose();
        _editingController.dispose();
        super.dispose();
    }

    Widget _buildPanel() {
        int category_index = 0;
        return ExpansionPanelList(
                expandedHeaderPadding: const EdgeInsets.all(0.0),
                expansionCallback: (int index, bool isExpanded) {
                    setState((){
                        _dayTodo.categoryList[index].isExpanded = !isExpanded;
                    });
                },
                children: _dayTodo.categoryList.map<ExpansionPanel>((Category category) {
                    return ExpansionPanel(
                            canTapOnHeader: true,
                            headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                        title: Text(category.headerValue),
                                        subtitle: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                                child: LinearProgressIndicator(
                                                        value: category.categoryValue,
                                                        backgroundColor: Colors.grey
                                                )),
                                        trailing: Text(category.itemList.length.toString()),
                                );
                            },
                            body: _todoListBuilder(category.itemList, category_index++),
                            isExpanded: category.isExpanded,
                    );
                }).toList(),
                );
    }

    Widget _todoAdd(int index){
        return Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Column(
                        children: [
                            Divider(),
                            Center(
                                    child: ElevatedButton.icon(
                                            icon: Icon(Icons.add),
                                            label: Text('Add'),
                                            onPressed: () {
                                                setState(() {
                                                    _dayTodo.categoryList[index].itemList.add(Item(todoTitle: 'Touch it to edit it'));
                                                });
                                            },
                                    ),
                            ),
                        ],
                ),
        );
    }

    Widget _editTodoTitle(Item item) {
        if(item.isEditingTitle)
            return TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    controller: _editingController,
                    onSubmitted: (newValue) {
                        setState(() {
                            item.todoTitle = newValue;
                            item.isEditingTitle = false;
                        });
                    },
                    focusNode: focusNode,
                    autofocus: true,
            );
        return InkWell(
                onTap: () {
                    setState(() {
                        item.isEditingTitle = true;
                        _editingItem = item;
                        _editingController = TextEditingController(text: item.todoTitle);
                    });
                },
                child: Text(item.todoTitle),
        );
    }

    Widget _todoUnit(List<Item> itemList, int index){
        return Container(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Column(
                        children: [ 
                        Divider(),
                        Row(
                                children: [
                                    Expanded(
                                            child: ListTile(
                                                    title: _editTodoTitle(itemList[index]),
                                            ),
                                    ),
                                    IconButton(
                                            onPressed: () {
                                                setState(() {
                                                    itemList.removeWhere((Item currentItem) => itemList[index] == currentItem);
                                                });
                                            },
                                            icon: Icon(Icons.delete),
                                    ),
                                ],
                        ),
                        SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.0),
                                        overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                                ),
                                child : Slider(
                                        value: itemList[index].itemValue,
                                        max: 100,
                                        divisions: 20,
                                        label: itemList[index].itemValue.round().toString(),
                                        onChanged: (double value){
                                            setState(() {
                                                itemList[index].itemValue = value;
                                            });
                                        },
                                ),
                                ),
                                ]),
                                );                   

    }

    Widget _todoListBuilder(List<Item> itemList, int category_index){
        return ListView.builder(
                padding: const EdgeInsets.only(bottom: 0.0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: itemList.length+1,
                itemBuilder: (BuildContext context, int index){
                    if(index == itemList.length){
                        return _todoAdd(category_index);
                    }
                    return _todoUnit(itemList, index);
                });
    }

    @override
    Widget build(BuildContext context) {
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
        return SingleChildScrollView(
                child: Column(
                        children: [
                            Divider(),
                            Container(
                                    margin: EdgeInsets.all(5),
                                    height: 10,
                                    child:  ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                            child: LinearProgressIndicator(
                                                    value: _dayTodo.dayValue,
                                                    backgroundColor: Colors.grey,
                                            ),
                                    ),
                            ),
                            Divider(),
                            Container(
                                    child: _buildPanel(),
                            ),
                        ],
                ),
        );
    }
}
