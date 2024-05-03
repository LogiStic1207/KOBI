import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
    GraphQLClient client = GraphQLProvider.of(context).value;
    String query = """
    query GetResponse(\$message: String!) {
      getResponse(message: \$message) {
        text
      }
    }
    """;
    final QueryOptions options = QueryOptions(
      document: gql(query),
      variables: {
        'message': message,
      },
    );
    final QueryResult result = await client.query(options);

    if (!result.hasException) {
      final responseText =
          result.data?['getResponse']?['text'] ?? "No response text.";
      setState(() {
        _messages.insert(0, {"text": responseText, "isBot": true});
        _isSending = false;
      });
    } else {
      setState(() {
        _messages.insert(0, {"text": "오류: 응답을 가져오는 데 실패했습니다.", "isBot": true});
        _isSending = false;
      });
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
      child: ListView(
        children: [
          DrawerHeader(
            child: Text('메뉴', style: TextStyle(color: Colors.white)),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
              title: Text('시간표 제작'),
              onTap: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TimetablePage()))),
          ListTile(
              title: Text('설정'),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OptionsPage()))),
          Divider(),
          ListTile(title: Text('로그아웃'), onTap: () {/* Logout logic */}),
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
