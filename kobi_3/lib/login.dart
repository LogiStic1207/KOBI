import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Widget/bezierContainer.dart';
import 'chatbotpage.dart';
import 'dashboard.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  final String? title;

  const Login({Key? key, this.title}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final ValueNotifier<bool> _isObscure = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  bool _isPasswordVisible = false;
  String userId = "";
  String userPw = "";
  BuildContext? _dialogContext;
  bool _isIdSaved = false;
  bool _keepLoggedIn = false;
  int _loginCount = 0;
  String _lastLoggedInId = "";

  @override
  void initState() {
    super.initState();
    //_loadLoginInfo();
  }

/*
  Future<void> _sendInfotoServer() async {
    print(_idController.text);
    print(_pwController.text);
    //final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = _idController.text;
      userPw = _pwController.text;
    });
    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatBotPage()));

  }
*/
  Future<void> _sendInfotoServer() async {
    // 새 ID 로그인 시 로그인 카운트 재설정
    if (_lastLoggedInId != _idController.text) {
      _loginCount = 0; // 새로운 ID의 첫 로그인
    }
    _showLoadingDialog(_loginCount == 0);
    try {
      var response = await _makeLoginRequest();
      var loginState = jsonDecode(response.body)["LoginState"];
      if (loginState) {
        _loginCount++; // 성공적인 로그인 횟수 증가
        await _savePreferences();
        Navigator.of(_dialogContext!).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
      } else {
        Navigator.of(_dialogContext!).pop();
        _showToast('로그인 실패');
      }
    } catch (e) {
      Navigator.of(_dialogContext!).pop();
      _showToast('네트워크 오류가 발생했습니다. 다시 시도해 주세요.');
      print('오류: $e');
    }
  }

  Future<http.Response> _makeLoginRequest() {
    var url = 'http://192.168.219.101:5000/login';
    return http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': _idController.text, 'pw': _pwController.text}),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          TextField(
              controller: isPassword ? _pwController : _idController,
              obscureText: isPassword ? _isObscure.value : false,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('loginCount', _loginCount);
    prefs.setBool('isIdSaved', _isIdSaved);
    prefs.setBool('keepLoggedIn', _keepLoggedIn);
    prefs.setString('lastLoggedInId', _idController.text); // 현재 ID 저장
    if (_isIdSaved) {
      prefs.setString('savedId', _idController.text);
    }
    if (_keepLoggedIn) {
      prefs.setString('savedPassword', _pwController.text);
    }
  }

  void _showLoadingDialog(bool isFirstLogin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _dialogContext = context;
        String message =
            isFirstLogin ? "로그인중입니다. 최초 1회 로그인 시 시간이 걸릴 수 있습니다." : "로그인중입니다.";
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 24),
              Expanded(child: Text(message))
            ],
          ),
        );
      },
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child:
                  const BezierContainer(), // Make sure this widget is properly defined elsewhere
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(), // Ensure this is defined elsewhere in your class
                  const SizedBox(height: 50),
                  _entryField("ID"),
                  _entryField("Password", isPassword: true),
                  const SizedBox(height: 20),
                  _submitButton(context),
                  _divider(), // Ensure this is defined elsewhere in your class
                  SizedBox(height: height * .055),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'KO',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)),
          children: [
            TextSpan(
                text: ' : ',
                style: TextStyle(color: Colors.black, fontSize: 30)),
            TextSpan(
                text: 'BI',
                style: TextStyle(color: Color(0xff0e5289), fontSize: 30)),
          ]),
    );
  }

  Widget _submitButton(BuildContext context) {
    return InkWell(
      onTap: _sendInfotoServer,
      onTap: _sendInfotoServer,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfff7892b), Color(0xff0e5289)],
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const <Widget>[
          SizedBox(width: 20),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(thickness: 1))),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(thickness: 1))),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
