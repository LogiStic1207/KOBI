import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kobi_3/menu/mypage.dart';
import 'package:kobi_3/menu/timetablepage.dart';
import 'menu/options.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  String _intent = "위치";
  String _ner = "해울관";
  final TextEditingController _controller = TextEditingController();
  //final List<Map<String, dynamic>> _messages = [];
  bool _isSending = false;
  // String res = 'hello world';
  // Define the size variables
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
        //_messages.insert(0, {"text": text, "isBot": false});
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
          _intent = responseData['Intent'];
          _ner = responseData['Ner'][0];
          //_messages.insert(0, {"text": responseData['Ner'][0], "isBot": true});
          _isSending = false;
        });
        print(_intent);
        print(_ner);
      } else {
        print('Failed to send message');
        setState(() {
          // _messages
          //     .insert(0, {"text": "Failed to fetch response", "isBot": true});
          _isSending = false;
        });
      }
    }
  }

  Widget _buildMessageBubble(String message) {
    //bool isBot = message["isBot"];
    return Align(
        //alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue[300],
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 16),
      ),
    ));
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
          Container(
            height: 500,
            child: Query(
              options: QueryOptions(
                  document: gql(query),
                  variables: {"_intent": _intent, "_ner": _ner}),
              builder: (result, {fetchMore, refetch}) {
                if (result.isLoading) {
                  return CircularProgressIndicator();
                }
                print(query);
                String answer = result.data!["answer"]["answer"];
                //print(result.data!["answer"]["answer"]);
                if (answer == null) {
                  return Text('No answer that ner');
                }

                //_messages.insert(0, {"text": answer, "isBot": true});
                return ListView.builder(
                  //final Map<String, dynamic> message;
                  itemCount: 1,
                  itemBuilder: (context, index) => index == 0 && _isSending
                      ? Center(child: CircularProgressIndicator())
                      : _buildMessageBubble(answer),
                );
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                IconButton(
                    onPressed: _sendMessage,
                    icon: Icon(Icons.send, color: Colors.blue))
              ]))
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _sendMessage,
      // ),
    );
  }
}
