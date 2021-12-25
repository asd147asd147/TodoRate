import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 

class MainListView extends StatefulWidget {
    @override
    _MainListViewState createState() => _MainListViewState();
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
        required this.expandedValue,
        this.itemValue = 0,
    });

    String expandedValue;
    double itemValue;
}

List<Category> generateCategory(int numberOfCategory) {
    return List<Category>.generate(numberOfCategory, (int index) {
        return Category(
            headerValue: 'Category $index',
            itemList: generateItems(3),
        );
    });
}

List<Item> generateItems(int numberOfItems) {
    return List<Item>.generate(numberOfItems, (int index) {
        return Item(
                expandedValue: 'This is todo number $index',
        );
    });
}

class _MainListViewState extends State<MainListView> {
    final List<Category> _data = generateCategory(4);

    Widget _buildPanel() {
        return ExpansionPanelList(
                expandedHeaderPadding: const EdgeInsets.all(0.0),
                expansionCallback: (int index, bool isExpanded) {
                    setState((){
                        _data[index].isExpanded = !isExpanded;
                    });
                },
                children: _data.map<ExpansionPanel>((Category category) {
                    return ExpansionPanel(
                            canTapOnHeader: true,
                            headerBuilder: (BuildContext context, bool isExpanded) {
                                return Row(
                                        children: [
                                            Expanded(
                                                    child: ListTile(
                                                            title: Text(category.headerValue),
                                                    ),
                                            ),
                                            IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.add),
                                            ),
                                        ],
                                );
                            },
                            body: _todoUnit(category.itemList),
                    isExpanded: category.isExpanded,
                    );
                }).toList(),
                );
    }

    Widget _todoUnit(List<Item> itemList){
        return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: itemList.length,
                itemBuilder: (BuildContext context, int index){
                    return Container(
                            padding: const EdgeInsets.all(1.0),
                            child: Column(
                                    children: [ 
                                    Divider(),
                                    Row(
                                            children: [
                                                Expanded(
                                                        child: ListTile(
                                                                title: Text(itemList[index].expandedValue),
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
                });
    }

    @override
    Widget build(BuildContext context) {
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
                                                    value: 0.4522,
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
