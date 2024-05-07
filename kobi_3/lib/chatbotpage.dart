import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kobi_3/menu/mypage.dart';
import 'package:kobi_3/menu/timetablepage.dart';
import 'menu/options.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _isSending = false;
  // String res = 'hello world';
  // Define the size variables
  double buttonWidth = 250.0;
  double buttonHeight = 50.0;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.insert(0, {"text": text, "isBot": false});
        _isSending = true;
      });

      // Send user message to the server and wait for the response
      var url = 'http://218.150.183.164:5000/query';
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'query': text}));
      _controller.clear();

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print(responseData);
        setState(() {
          _messages
              .insert(0, {"text": responseData['response'], "isBot": true});
          _isSending = false;
        });
      } else {
        print('Failed to send message');
        setState(() {
          _messages
              .insert(0, {"text": "Failed to fetch response", "isBot": true});
          _isSending = false;
        });
      }
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isBot = message["isBot"];
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isBot ? Colors.grey[300] : Colors.blue[300],
        ),
        child: Text(
          message["text"],
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 65,
                  child: DrawerHeader(
                    child: Text('메뉴', style: TextStyle(color: Colors.white)),
                    decoration: BoxDecoration(color: Colors.blue),
                  ),
                ),
                ListTile(
                    title: Text('시간표 제작'),
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimetablePage()))),
                ListTile(
                    title: Text('설정'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OptionsPage()))),
                Divider(),
              ],
            ),
          ),
          Container(
            width: buttonWidth,
            height: buttonHeight,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: ListTile(
                title: Text(
                  '로그아웃',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                onTap: () {/* Logout logic */},
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KOBI"),
        actions: [
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyPage()))),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length + (_isSending ? 1 : 0),
              itemBuilder: (context, index) => index == 0 && _isSending
                  ? Center(child: CircularProgressIndicator())
                  : _buildMessageBubble(
                      _messages[index - (_isSending ? 1 : 0)]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "메시지를 입력하세요...",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onSubmitted: (text) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
