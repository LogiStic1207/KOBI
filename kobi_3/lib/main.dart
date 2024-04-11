import 'package:flutter/material.dart';
import './login.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CNU Dorm 자가진단',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CNU Dorm 자가진단'),
          actions: [Icon(Icons.calendar_month)
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Login(),
        ),
      ),
    );
  }
}