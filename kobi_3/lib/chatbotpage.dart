import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  final String _storedId;
  final String _storedPw;
  final VoidCallback _resetLoginInfo;
  final Map<String, String> _headers;

  ChatBotPage(this._storedId, this._storedPw, this._resetLoginInfo, this._headers);

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
    // 모의 챗봇 응답 시간 설정
    await Future.delayed(Duration(seconds: 2));

    // 모의 챗봇 응답
    setState(() {
      _messages.insert(0, {"text": "이것은 챗봇의 응답입니다.", "isBot": true});
      _isSending = false;
    });
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isBot = message["isBot"];
    return Container(
      padding: EdgeInsets.all(8),
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("챗봇 페이지"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessageBubble(_messages[index]),
            ),
          ),
          _isSending ? LinearProgressIndicator() : SizedBox(),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                  ),
                ),
                SizedBox(width: 8),
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