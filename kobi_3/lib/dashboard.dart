import 'package:flutter/material.dart';
import 'chatbotpage.dart';
import 'menu/options.dart';
import 'menu/timetablepage.dart';
import 'menu/mypage.dart';
import 'menu/inquiry_page.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.question_answer),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InquiryPage()),
              );
            },
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0, // 조정하여 타일의 크기와 비율을 맞춤
        children: <Widget>[
          _buildTile(context, "ChatBot", Icons.chat, Colors.blue, ChatBotPage()),
          _buildTile(context, "Settings", Icons.settings, Colors.orange, OptionsPage()),
          _buildTile(context, "Timetable", Icons.calendar_today, Colors.green, TimetablePage()),
          // 다른 타일들 추가 가능
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, String title, IconData icon, Color color, Widget destination) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            SizedBox(height: 50.0),
            Icon(icon, size: 40.0, color: color),
            SizedBox(height: 20.0),
            Center(
              child: Text(title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
