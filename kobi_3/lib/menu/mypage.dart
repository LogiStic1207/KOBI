import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String _namenum = "";
  String _email = "";
  List<dynamic> _coursehistory = [];
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _namenum = prefs.getString('_namenum') ?? '';
      _email = prefs.getString('_email') ?? '';
      _coursehistory = json.decode(prefs.getString('_coursehistory') ?? '[]');
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(_namenum);
    return Scaffold(
        appBar: AppBar(
          title: Text('학생정보조회'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildUserInfoCard('이름(학번)', _namenum),
              _buildUserInfoCard('이메일', _email),
              _buildCourseHistorySection(),
            ],
          ),
        ));
  }

  Widget _buildUserInfoCard(String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildCourseHistorySection() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '수강강의(분반)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            ..._coursehistory
                .map((course) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(course),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
