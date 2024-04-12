import 'package:flutter/material.dart';

class OptionsPage extends StatefulWidget {
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String? _notificationMode =
      '소리'; // Ensure this matches an item in your list exactly

  final List<String> _notificationModes = ['진동', '소리', '진동 & 소리', '무음'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: Text('알림 활성화'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          ListTile(
            title: Text('알림 방식'),
            trailing: DropdownButton<String>(
              value: _notificationsEnabled ? _notificationMode : null,
              onChanged: _notificationsEnabled
                  ? (String? newValue) {
                      setState(() {
                        _notificationMode = newValue;
                      });
                    }
                  : null,
              items: _notificationModes
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Select Mode'),
              disabledHint: Text('꺼짐'), // Text when notifications are disabled
            ),
          ),
          Divider(),
          SwitchListTile(
            title: Text('어두운 모드'),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          Divider(),
          // Additional settings can be added here
        ],
      ),
    );
  }
}
