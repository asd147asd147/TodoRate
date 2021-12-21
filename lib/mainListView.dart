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
        this.isExpanded = true,
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
                expansionCallback: (int index, bool isExpanded) {
                    setState((){
                        _data[index].isExpanded = !isExpanded;
                    });
                },
                children: _data.map<ExpansionPanel>((Item item) {
                    return ExpansionPanel(
                            headerBuilder: (BuildContext context, bool isExpanded) {
                                return ListTile(
                                        title: Text(item.headerValue),
                                );
                            },
                            body: Dismissible(
                                          background: Container(color : Colors.red,),
                                          direction: DismissDirection.startToEnd,
                                          onDismissed: (direction){
                                              if(direction == DismissDirection.startToEnd){
                                                  setState(() {
                                                      _data.removeWhere((Item currentItem) => item == currentItem);
                                                  });
                                              }
                                          },
                                          child: _todoUnit(item),
                                          key: Key(UniqueKey().toString()),
                                  ),
                    isExpanded: item.isExpanded,
                    );
                }).toList(),
                );
    }
    double _value = 0.0;

    Widget _todoUnit(Item item){
        return Column(
                children: [
                    ListTile(
                            title: Text(item.expandedValue),
                            subtitle: const Text('To delete this panel'),
                    ),
                    SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 4.0),
                                    overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                            ),
                            child : Slider(
                                    value: _value,
                                    max: 100,
                                    divisions: 100,
                                    label: _value.round().toString(),
                                    onChanged: (double value){
                                        setState(() {
                                            _value = value;
                                        });
                                    }
                            ),
                    ),
                    ]);
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
