import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kobi_3/menu/mypage.dart';
import 'package:kobi_3/menu/timetablepage.dart';
import 'menu/options.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  //String _intent = "위치";
  //String _ner = "해울관";
  String _answer = "초기 응답입니다.";
  String _menulink = "학식 메뉴 링크입니다.";
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  //bool ismenulink = false;

  @override
  void initState() {
    super.initState();
    // 기본 챗봇 메시지 추가
    _messages.add(
        {"text": "안녕하세요. 여러분만의 코리아텍 비서, 코비입니다.\n무엇을 도와드릴까요?", "isBot": true});
  }

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
      var url = 'http://192.168.219.101:5000/query';
      var response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'query': text}));

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        //print(responseData);

        setState(() {
          _answer = responseData['Answer'];
          if (responseData.containsKey('Link')) {
            _menulink = responseData['Link'];
            _messages.add({"text": _answer, "isBot": true, "Link": _menulink});
          } else {
            _messages.add({"text": _answer, "isBot": true});
          }
        });
        //print(_messages);
      } else {
        print('Failed to send message');
        setState(() {
          _messages.add({"text": "Failed to fetch response", "isBot": true});
        });
      }
    }
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(_menulink))) {
      throw Exception('링크 오류!');
    }
  }

  bool checkLinkMessage(Map<String, dynamic> _message) {
    return _message.containsKey('Link');
  }

  Widget _buildMessageBubble(Map<String, dynamic> _message) {
    bool isBot = _message["isBot"];
    bool isLinkMessage = checkLinkMessage(_message);
    //print(isLinkMessage);
    // 챗봇 프로필과 이름을 가로로 나열하는 위젯
    Widget botHeader = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/logo.png', width: 40, height: 40), // 챗봇 프로필 사진
        SizedBox(width: 7), // 프로필 사진과 이름 사이의 간격
        Text("코비",
            style: TextStyle(fontSize: 14, color: Colors.grey[600])), // 챗봇 이름
      ],
    );

    Widget generalText = Text(_message['text'],
        style: TextStyle(fontSize: 16, color: Colors.black));

    Widget linkText = Column(
      children: [
        Text(
          _message['text'],
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        RichText(
            text: TextSpan(
                text: _menulink,
                style: const TextStyle(color: Colors.blueAccent),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchUrl();
                  }))
      ],
    );
    // 메시지 텍스트
    Widget messageText = Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: EdgeInsets.symmetric(
          vertical: 4, horizontal: 16), // 여백을 추가하여 화면 가장자리와 거리를 두도록 함
      decoration: BoxDecoration(
        color:
            isBot ? Colors.lightBlue[100] : Colors.grey[300], // 챗봇과 사용자 메시지 색상
        borderRadius: BorderRadius.circular(18), // 모서리를 둥글게 처리하여 말풍선 효과 적용
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2), // 그림자 효과
          )
        ],
      ),
      child: isLinkMessage ? linkText : generalText,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Align(
        alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
        child: Column(
          crossAxisAlignment:
              isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: isBot
              ? [botHeader, messageText]
              : [messageText], // 사용자 메시지에는 프로필과 이름이 포함되지 않음
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 시간표 제작 버튼
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
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
                          backgroundColor: Colors.orange,
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
          Row(
            children: [
              Expanded(
                child: Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
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
              IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.blue),
                onPressed: () => _confirmExit(context),
                tooltip: '채팅창 나가기',
              ),
            ],
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

  void _confirmExit(BuildContext context) async {
    final bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('채팅창 나가기'),
          content: Text('채팅창을 나가시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(true), // 대화 상자를 닫고 true를 반환
              child: Text('예'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(false), // 대화 상자를 닫고 false를 반환
              child: Text('아니오'),
            ),
          ],
        );
      },
    );

    if (confirm) {
      Navigator.pushReplacement(
        // 사용자가 '예'를 선택했을 때 DashboardPage로 이동
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    }
  }
}
