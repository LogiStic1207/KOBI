import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kobi_3/menu/mypage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  String _answer = "초기 응답입니다.";
  String _menulink = "학식 메뉴 링크입니다.";
  String _hasMap = "맵 플래그입니다.";
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({"text": text, "isBot": false});
      });
      _controller.clear();
      _scrollToEnd();
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
            _hasMap = responseData['Img'];
            _messages.add({"text": _answer, "isBot": true, "Img": _hasMap});
          }
        });
        //print(_messages);
        _scrollToEnd();
      } else {
        setState(() {
          _messages.add({"text": "Failed to fetch response", "isBot": true});
        });
        _scrollToEnd();
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

  bool checkImgMessage(Map<String, dynamic> _message) {
    return _message.containsKey("Img") && _message["Img"] == "map";
  }

  Widget _buildMessageBubble(Map<String, dynamic> _message) {
    bool isBot = _message["isBot"];
    bool isLinkMessage = checkLinkMessage(_message);
    bool isImgMessage = checkImgMessage(_message);
    //print(isLinkMessage);
    // 챗봇 프로필과 이름을 가로로 나열하는 위젯
    Widget botHeader = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/logo.png', width: 40, height: 40),
        SizedBox(width: 7),
        Text("코비", style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );

    Widget generalText = Text(_message['text'],
        style: TextStyle(fontSize: 16, color: Colors.black));

    Widget linkText = Column(
      children: [
        generalText,
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

    Widget imgText = Column(
      children: [
        generalText,
        Image.asset('assets/testmap.png', width: 400, height: 300),
      ],
    );

    // 메시지 텍스트
    Widget messageText = Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: isBot ? Colors.lightBlue[100] : Colors.grey[300],
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: isLinkMessage
          ? linkText
          : isImgMessage
              ? imgText
              : generalText,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Align(
        alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
        child: Column(
          crossAxisAlignment:
              isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: isBot ? [botHeader, messageText] : [messageText],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KOBI : 챗봇"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardPage()),
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/logo.png",
              width: 300,
              height: 300,
              color: Colors.white.withOpacity(0.2),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 136,
            child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessageBubble(_messages[index]);
                }),
          ),
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
