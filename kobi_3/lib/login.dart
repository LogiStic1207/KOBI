//import 'package:koreatech_chatbot/mypage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './exception_handlers.dart';
//import 'dart:html' as html;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(message),
        action: SnackBarAction(
            label: '확인', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  var _storedId;
  var _storedPw;
  bool _changeMod = true;
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  Map<String, String> _headers = {}; // Client header

  // 시작할 때 id, pw 값 불러오기
  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
  }

  void _loadLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userId') == null ||
        prefs.getString('userPw') == null) {
      setState(() {
        _changeMod = true;
      });
      print(1);
    } else {
      setState(() {
        _storedId = (prefs.getString('userId'));
        _storedPw = (prefs.getString('userPw'));
        _changeMod = false;
      });
      print('2');
      _loginRequest();
    }
  }

  /*
  void _resetLoginInfo() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedId = null;
      _storedPw = null;
      _changeMod = true;
    });
  }
  */
  void _loginRequest() async {
    if (_changeMod == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        print(_idController.text);
        /*
        var formData = {
          'anchor': html.window.location.hash,
          'id': 'EL2',
          'RelayState': '/local/sso/index.php',
          'user_id': _idController.text,
          'user_password': _pwController.text,
        };
        */
        final response = await http.post(
          Uri.parse('https://tsso.koreatech.ac.kr/svc/tk/Login.do'),
          //body: formData,

          body: {
            'id': 'login',
            'user_id': _idController.text,
            'user_password': _pwController.text,
          }, // 로그인 input
        ).timeout(Duration(seconds: 5));
        print('Response status: ${response.statusCode}'); //500에러 발생!
        print('Reason: ${response.reasonPhrase}');

        if (response.statusCode == 200) {
          // 연결됨
          print('데이터 수신 ' + response.contentLength.toString() + 'byte');
          if (response.body.contains('alert')) {
            // 로그인 성공여부 확인
            print('login failed');
            _showToast(context, '로그인 실패. ID/PW를 확인해주세요');
          } else {
            print('로그인 성공');
            _showToast(context, '로그인 성공');
            setState(() {
              _storedId = _idController.text;
              _storedPw = _pwController.text;
              prefs.setString('userId', _storedId);
              prefs.setString('userPw', _storedPw);
              _changeMod = false;
            });
          }

          //String rawCookie = response.headers['set-cookie'].toString();
          /*
          if (rawCookie != null) {
            // 웹서버로부터 받은 set-cookie
            int idx = rawCookie.indexOf(';');
            _headers['Cookie'] = rawCookie.substring(
                0, idx); // PHPSESSID 추출 후 클라이언트 헤더 Cookie에 저장
          }
          print(_headers['Cookie']); // print PHPSESSID
          */
          print(response.body); // 한글이 깨지는 문제를 해결
        }
      } catch (e) {
        throw ExceptionHandlers().getExceptionString(e);
      }
    } else {
      try {
        final response = await http.post(
          Uri.parse('https://tsso.koreatech.ac.kr/svc/tk/Login.do'),
          body: {
            'id': 'login',
            'user_id': _storedId,
            'user_password': _storedPw,
          }, // 로그인 input
        ).timeout(Duration(seconds: 5));

        if (response.statusCode == 200) {
          // 연결됨
          print('데이터 수신 ' + response.contentLength.toString() + 'byte');
          if (response.body.contains('alert')) {
            // 로그인 성공여부 확인
            print('login failed');
            _showToast(context, '로그인 실패. ID/PW를 확인해주세요');
          } else {
            _showToast(context, '로그인 성공');
          }

          String rawCookie = response.headers['set-cookie'].toString();
          print('rawc' + rawCookie);
          /*
          if (rawCookie != null) {
            // 웹서버로부터 받은 set-cookie
            int idx = rawCookie.indexOf(';');
            setState(() {
              _headers['Cookie'] = rawCookie.substring(
                  0, idx); // PHPSESSID 추출 후 클라이언트 헤더 Cookie에 저장
            });
            print('1:' + _headers['Cookie'].toString()); // print PHPSESSID
          }*/
          print(response.body); // 한글이 깨지는 문제를 해결
        }
      } catch (e) {
        throw ExceptionHandlers().getExceptionString(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_headers['Cookie']);
    return _storedId != null &&
            _storedPw != null &&
            _changeMod == false &&
            _headers['Cookie'] != null
        ? Container(
            child: Text('로그인 성공!'),
          )
        : Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: '정보시스템 ID',
                        ),
                        controller: _idController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: 'Password',
                        ),
                        obscureText: true,
                        controller: _pwController,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  // 로그인 버튼
                  onPressed: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _loginRequest();
                  },
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
