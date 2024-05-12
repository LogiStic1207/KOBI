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

    // 챗봇 메시지일 경우 프로필 아이콘과 이름을 포함하는 위젯
    Widget botProfile = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/logo.png', width: 24, height: 24), // 챗봇 아이콘
        Text("코봇", style: TextStyle(fontSize: 12, color: Colors.black)) // 챗봇 이름
      ],
    );

    return Row(
      mainAxisAlignment:
          isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start, // 챗봇 아이콘과 텍스트를 위쪽에 맞추기
      children: [
        if (isBot) botProfile, // 챗봇 메시지이면 프로필을 표시
        Flexible(
          // 텍스트의 유연한 레이아웃 적용
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isBot ? Colors.orange : Colors.blue[300],
            ),
            child: Text(
              _message['text'],
              style: TextStyle(fontSize: 16, color: Colors.white),
              softWrap: true,
            ),
          ),
        ),
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 시간표 제작 버튼
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffe46b10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(16), // 버튼 내부 패딩
                          fixedSize: Size(120, 120), // 버튼의 고정 사이즈 설정
                        ),
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TimetablePage())),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.schedule, color: Colors.white), // 아이콘
                            Text(
                              '시간표 제작',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      // 설정 버튼
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffe46b10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(16),
                          fixedSize: Size(120, 120), // 동일한 사이즈로 설정
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OptionsPage())),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.settings, color: Colors.white), // 아이콘
                            Text(
                              '설정',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
        title: Text("KOBI : 챗봇"),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyPage())),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // 배경 이미지 추가
          Center(
            child: Image.asset(
              "assets/logo.png",
              width: 300, // 이미지의 너비를 300 픽셀로 설정
              height: 300, // 이미지의 높이를 300 픽셀로 설정
              color: Colors.white.withOpacity(0.2), // 이미지를 연하게 처리
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          // 메시지 리스트 및 입력 필드를 포함하는 메인 컨테츠
          Container(
            height: MediaQuery.of(context).size.height - 136,
            child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                }),
          ),
          // "무엇이든 물어보세요" 텍스트 추가
          Positioned(
            bottom: 500,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'KO',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xffe46b10).withOpacity(0.2)),
                  children: [
                    TextSpan(
                        text: ' : ',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.2),
                            fontSize: 30)),
                    TextSpan(
                        text: 'BI',
                        style: TextStyle(
                            color: Color(0xff0e5289).withOpacity(0.2),
                            fontSize: 30)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomSheet(),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, -1),
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
    );
  }
}
