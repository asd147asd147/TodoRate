import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './todo.dart';

class DrawerView extends StatefulWidget {
    @override
    _DrawerViewState createState() => _DrawerViewState();
}

class _DrawerViewState extends State<DrawerView> {
    late AllTodo allTodo;
    late CategoryList categoryList;
    late CategoryUnit _editingUnit;
    late TextEditingController _editingController;
    final focusNode = FocusNode();

    @override
    void initState() {
        super.initState();
        _editingController = TextEditingController(text: '');
        focusNode.addListener(() {
            if(!focusNode.hasFocus) {
                setState(() {
                    _editingUnit.categoryTitle = _editingController.text;
                    _editingUnit.isEditingTitle = false;
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

    Widget _editTodoTitle(List<CategoryUnit> items, int index) {
        CategoryUnit item = items[index];
        if(item.isEditingTitle)
            return TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    controller: _editingController,
                    onSubmitted: (newValue) {
                        setState(() {
                            item.categoryTitle = newValue;
                            item.isEditingTitle = false;
                            allTodo.editCategory(newValue, index);
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
                                _editingUnit.categoryTitle = _editingController.text;
                                _editingUnit.isEditingTitle = false;
                            }
                        });
                        item.isEditingTitle = true;
                        _editingUnit = item;
                        _editingController = TextEditingController(text: item.categoryTitle);
                    });
                },
                child: Text(item.categoryTitle),
        );
    }

    Widget _reorderableListViewBuilder() {
        return ReorderableListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categoryList.items.length,
                itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                            title: _editTodoTitle(categoryList.items, index),
                            key: Key('$index'),
                            trailing: IconButton(
                                    onPressed: () {
                                        setState(() {
                                            categoryList.items.removeWhere((CategoryUnit currentDrawer) {
                                                return categoryList.items[index] == currentDrawer;
                                            });
                                                allTodo.removeCategory(index);
                                            categoryList.changeCategory();
                                        });
                                    },
                                    icon: Icon(Icons.delete),
                            ),
                    );

                },
                onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                        if(oldIndex < newIndex) {
                            newIndex -= 1;
                        }
                        final CategoryUnit category = categoryList.items.removeAt(oldIndex);
                        categoryList.items.insert(newIndex, category);
                        allTodo.changeIndex(oldIndex, newIndex);
                    });
                },
                header: DrawerHeader(
                                margin: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                        color: Colors.blue,
                                ),
                                child: Text('Drawer Header'),
                        ),
                );
    }

    @override
    Widget build(BuildContext context) {
        allTodo = context.watch<AllTodo>();
        categoryList = allTodo.categoryList;

        return Drawer(
                child: SingleChildScrollView(
                        child: Column(
                                children: [
                                    _reorderableListViewBuilder(),
                                    Container(
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
                                                                                allTodo.addCategory('New Category');
                                                                            });
                                                                        },
                                                                ),
                                                        ),
                                                    ],
                                            ),
                                    ),
                                    ],
                                ),
                        ),
                );
    }
}
