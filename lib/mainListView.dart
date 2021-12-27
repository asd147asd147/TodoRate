import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import './todo.dart';

class MainListView extends StatefulWidget {
    @override
    _MainListViewState createState() => _MainListViewState();
}

class _MainListViewState extends State<MainListView> {
    late TextEditingController _editingController;
    late Item _editingItem;
    final focusNode = FocusNode();
    late DayTodo _dayTodo;

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
                                                    _dayTodo.categoryList[index].itemList.add(Item(todoTitle: 'Edit touch'));
                                                    _dayTodo.changeDayValue();
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
                        focusNode.addListener(() {
                            if(focusNode.hasFocus) {
                                _editingItem.todoTitle = _editingController.text;
                                _editingItem.isEditingTitle = false;
                            }
                        });
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
                        Slidable(
                                endActionPane: ActionPane(
                                        extentRatio: 0.15,
                                        motion: ScrollMotion(),
                                        children: [
                                            SlidableAction(
                                                    onPressed: (_) {
                                                        setState(() {
                                                            itemList.removeWhere((Item currentItem) => itemList[index] == currentItem);
                                                            _dayTodo.changeDayValue();
                                                        });
                                                    },
                                                    backgroundColor: Color(0xFFFE4A49),
                                                    foregroundColor: Colors.white,
                                                    icon: Icons.delete,
                                            ),
                                        ],
                                ),
                                child: ListTile(
                                        title: _editTodoTitle(itemList[index]),
                                ),
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
                                                _dayTodo.changeDayValue();
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
        _dayTodo = context.watch<DayTodo>();

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
