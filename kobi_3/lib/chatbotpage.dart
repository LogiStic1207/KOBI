import 'package:flutter/material.dart';
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
  //String _intent = "위치";
  //String _ner = "해울관";
  String _answer = "초기 응답입니다.";
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  double buttonWidth = 250.0;
  double buttonHeight = 50.0;

  String query = r"""
        query get($_intent: String!, $_ner: String!){
          answer(intent:$_intent, ner:$_ner){
            answer
            image
          }
        }
  """;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({"text": text, "isBot": false});
        //_isSending = true;
      });
      _controller.clear();
      // Send user message to the server and wait for the response
      var url = 'http://218.150.183.164:5000/query';
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'query': text}));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        print(responseData);

        setState(() {
          _answer = responseData['Answer'];

          //_intent = responseData['Intent'];
          // _intent = responseData['Intent'];
          // _ner = responseData['Ner'][0];
          _messages.add({"text": _answer, "isBot": true});
          //_isSending = false;
        });
        print(_answer);
      } else {
        print('Failed to send message');
        setState(() {
          _messages.add({"text": "Failed to fetch response", "isBot": true});
          //_isSending = false;
        });
      }
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> _message) {
    bool isBot = _message["isBot"];
    Widget avatar = isBot
        ? Image.asset('assets/logo.png', width: 24, height: 24) // 챗봇 아이콘
        : Icon(Icons.person, size: 24, color: Colors.blue); // 사용자 아이콘

    return Row(
      mainAxisAlignment:
          isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (!isBot) avatar, // 사용자 메시지이면 아이콘을 텍스트 앞에 배치
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isBot ? Colors.grey[200] : Colors.blue[300],
          ),
          child: Text(
            _message['text'],
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        if (isBot) avatar, // 챗봇 메시지이면 아이콘을 텍스트 뒤에 배치
      ],
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
                context, MaterialPageRoute(builder: (context) => MyPage())),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height -
            136, // AppBar와 bottomSheet의 높이를 고려한 값
        child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _buildMessageBubble(_messages[index]);
            }),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, -1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "메시지를 입력하세요...",
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: _sendMessage,
                icon: Icon(Icons.send, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
