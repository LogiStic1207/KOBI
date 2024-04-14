import 'package:flutter/material.dart';
import 'package:kobi_3/menu/mypage.dart';
import 'package:kobi_3/menu/timetablepage.dart';
import 'menu/options.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _isSending = false;

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.insert(0, {"text": text, "isBot": false});
        _isSending = true;
      });
      _controller.clear();
      _simulateBotResponse(text);
    }
  }

  Future<void> _simulateBotResponse(String message) async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _messages.insert(0, {"text": "이것은 챗봇의 응답입니다.", "isBot": true});
      _isSending = false;
    });
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isBot = message["isBot"];
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      title: Text(
        message["text"],
        style: TextStyle(fontSize: 16),
        textAlign: isBot ? TextAlign.left : TextAlign.right,
      ),
      tileColor: isBot ? Colors.grey[300] : Colors.blue[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
      drawer: ChatDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  _buildMessageBubble(_messages[index]),
            ),
          ),
          _isSending ? LinearProgressIndicator() : SizedBox(height: 4),
          MessageInputField(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function onSend;

  const MessageInputField(
      {Key? key, required this.controller, required this.onSend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "메시지를 입력하세요...",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () => onSend(),
          ),
        ],
      ),
    );
  }
}

class ChatDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child:
                Text('메뉴', style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            title: Text('시간표 제작'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => TimetablePage())),
          ),
          ListTile(
            title: Text('설정'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => OptionsPage())),
          ),
          ListTile(
            title: Text('로그아웃'),
            onTap: () {
              // 로그아웃 로직 구현
            },
          ),
        ],
      ),
    );
  }
}
