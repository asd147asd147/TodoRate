import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    // This widget is the root of your application.
    @override
    Widget build(BuildContext context) {
        Widget titleSection = Container(
            padding: const EdgeInsets.all(32),
            child: Row(
                children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Container(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text(
                                        'My Todo List',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                ),
                                Text(
                                    'IOS Update complete',
                                    style: TextStyle(
                                            color : Colors.grey[500],
                                    ),
                                ),
                            ],
                        ),
                    ),
                    Icon(
                        Icons.star,
                        color: Colors.red[500],
                    ),
                    Text('41'),
                ],
            ),        
        );
        Color color = Theme.of(context).primaryColor;
     
         Widget buttonSection = Container(
             child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                     _buildButtonCOlumn(color, Icons.call, 'CALL'),
                     _buildButtonCOlumn(color, Icons.near_me, 'ROUTE'),
                    _buildButtonCOlumn(color, Icons.share, 'SHARE'),
                ],
            ),
        );

        return MaterialApp(
            title: 'Startup Name Generator',
            home: Scaffold(
                body: Column(
                    children: [
                        titleSection,
                        buttonSection,
                    ],
                ),
            ),
        );
    }
    Column _buildButtonCOlumn(Color color, IconData icon, String label) {
        return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Icon(icon, color: color),
                Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Text(
                        label,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: color,    
                        ),
                    ),
                ),
            ],
        );
    }
}
