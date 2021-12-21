import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; 

class MainListView extends StatefulWidget {
    @override
    _MainListViewState createState() => _MainListViewState();
}

class Item {
    Item({
        required this.expandedValue,
        required this.headerValue,
        this.itemValue = 0,
        this.isExpanded = false,
    });

    String expandedValue;
    String headerValue;
    double itemValue;
    bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
    return List<Item>.generate(numberOfItems, (int index) {
        return Item(
                headerValue: 'Panel $index',
                expandedValue: 'This is item number $index',
        );
    });
}

class _MainListViewState extends State<MainListView> {
    final List<Item> _data = generateItems(8);

    Widget _buildPanel() {
        return ExpansionPanelList(
                //expandedHeaderPadding: const EdgeInsets.all(30.0),
                expansionCallback: (int index, bool isExpanded) {
                    setState((){
                        _data[index].isExpanded = !isExpanded;
                    });
                },
                children: _data.map<ExpansionPanel>((Item item) {
                    return ExpansionPanel(
                            headerBuilder: (BuildContext context, bool isExpanded) {
                                return Row(
                                        children: [
                                            Expanded(
                                                    child: ListTile(
                                                            title: Text(item.headerValue),
                                                    ),
                                            ),
                                            IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.add),
                                            ),
                                        ],
                                );
                            },
                            body: _todoUnit(item),
                    isExpanded: item.isExpanded,
                    );
                }).toList(),
                );
    }

    Widget _todoUnit(Item item){
        return Container(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                        children: [ 
                        Dismissible(
                                background: Container(color : Colors.red,),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (direction){
                                    if(direction == DismissDirection.startToEnd){
                                        setState(() {
                                            _data.removeWhere((Item currentItem) => item == currentItem);
                                        });
                                    }
                                },
                                child: ListTile(
                                               title: Text(item.expandedValue),
                                               subtitle: const Text('To delete this panel'),
                                       ),
                                key: Key(UniqueKey().toString()),
                        ),
                        SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.0),
                                        overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                                ),
                                child : Slider(
                                        value: item.itemValue,
                                        max: 100,
                                        divisions: 20,
                                        label: item.itemValue.round().toString(),
                                        onChanged: (double value){
                                            setState(() {
                                                item.itemValue = value;
                                            });
                                        },
                                ),
                        ),
                        ]),
                        );
    }


    @override
    Widget build(BuildContext context) {
        return SingleChildScrollView(
                child: Container(
                        child: _buildPanel(),
                ),
        );
    }
}
