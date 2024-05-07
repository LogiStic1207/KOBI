import 'chatbotpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './exception_handlers.dart';
import 'package:dio/dio.dart';
//import 'dart:html' as html;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  dynamic dioResultJson ='';
  String dioResultValue = '';
  String _userInfo = "초기";
  bool _isObscure = false;
  
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
  //Map<String, String> _headers = {}; // Client header

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
  /*
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
          Uri.parse('https://portal.koreatech.ac.kr/login.jsp'),
          //body: formData,
          body: {
            'user_id': _idController.text, // 사용자 ID
            'user_pwd': _pwController.text, // 사용자 비밀번호
            'RelayState': '/index.jsp',
            'id': 'PORTAL', // doPortalLogin()에서 추가된 숨겨진 필드들
            'targetId': 'PORTAL',
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
            'user_id': _idController.text, // 사용자 ID
            'user_pwd': _pwController.text, // 사용자 비밀번호
            'RelayState': '/index.jsp',
            'id': 'PORTAL', // doPortalLogin()에서 추가된 숨겨진 필드들
            'targetId': 'PORTAL',
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
            ;
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
  */
  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png',
                  width: 250, height: 200, fit: BoxFit.fill), // 로고 이미지
              SizedBox(height: 20), // 로고와 제목 사이의 간격
              Text(
                'KOBI: 코리아텍 비서',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20), // 제목과 입력필드 사이의 간격
              Container(
                margin:
                    EdgeInsets.only(bottom: 10), // ID 박스와 Password 박스 사이의 간격
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none, // 텍스트 필드 테두리 제거
                    hintText: 'ID',
                    contentPadding: EdgeInsets.all(10), // 내부 패딩
                  ),
                  controller: _idController,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none, // 텍스트 필드 테두리 제거
                    hintText: 'Password',
                    contentPadding: EdgeInsets.all(10), // 내부 패딩
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: _isObscure,
                  controller: _pwController,
                ),
              ),
              SizedBox(height: 20), // 입력필드와 로그인 버튼 사이의 간격
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ChatBotPage()),
                  );
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _loginRequest();
                },
                child:
                    Text('로그인', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
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
          Uri.parse('https://portal.koreatech.ac.kr/login.jsp'),
          //body: formData,
          body: {
            'user_id': _idController.text, // 사용자 ID
            'user_pwd': _pwController.text, // 사용자 비밀번호
            'RelayState': '/index.jsp',
            'id': 'PORTAL', // doPortalLogin()에서 추가된 숨겨진 필드들
            'targetId': 'PORTAL',
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
          Uri.parse('https://portal.koreatech.ac.kr/login.jsp'),
          body: {
            'user_id': _idController.text, // 사용자 ID
            'user_pwd': _pwController.text, // 사용자 비밀번호
            'RelayState': '/index.jsp',
            'id': 'PORTAL', // doPortalLogin()에서 추가된 숨겨진 필드들
            'targetId': 'PORTAL',
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
            ;
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

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_userInfo),
              //Text('json: ${dioResultJson}'),
              //Text('값: ${dioResultValue}'),
              Image.asset('assets/logo.png',
                  width: 250, height: 200, fit: BoxFit.fill), // 로고 이미지
              SizedBox(height: 20), // 로고와 제목 사이의 간격
              Text(
                'KOBI: 코리아텍 비서',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20), // 제목과 입력필드 사이의 간격
              Container(
                margin:
                    EdgeInsets.only(bottom: 10), // ID 박스와 Password 박스 사이의 간격
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none, // 텍스트 필드 테두리 제거
                    hintText: 'ID',
                    contentPadding: EdgeInsets.all(10), // 내부 패딩
                  ),
                  controller: _idController,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none, // 텍스트 필드 테두리 제거
                    hintText: 'Password',
                    contentPadding: EdgeInsets.all(10), // 내부 패딩
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isObscure,
                  controller: _pwController,
                ),
              ),
              SizedBox(height: 20), // 입력필드와 로그인 버튼 사이의 간격
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ChatBotPage()),
                  );
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _loginRequest();
                },
                child:
                    Text('로그인', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
