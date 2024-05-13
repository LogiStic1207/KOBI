import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Widget/bezierContainer.dart';
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
  BuildContext? _dialogContext;
  bool _isIdSaved = false;
  bool _keepLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isIdSaved = prefs.getBool('isIdSaved') ?? false;
      _keepLoggedIn = prefs.getBool('keepLoggedIn') ?? false;
      if (_isIdSaved) {
        _idController.text = prefs.getString('savedId') ?? '';
      }
      if (_keepLoggedIn) {
        _pwController.text = prefs.getString('savedPassword') ?? '';
      }
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isIdSaved', _isIdSaved);
    prefs.setBool('keepLoggedIn', _keepLoggedIn);
    if (_isIdSaved) {
      prefs.setString('savedId', _idController.text);
    }
    if (_keepLoggedIn) {
      prefs.setString('savedPassword', _pwController.text);
    }
  }

  Future<void> _sendInfotoServer() async {
    _showLoadingDialog();
    try {
      var url = 'http://172.29.64.228:5000/login';
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': _idController.text, 'pw': _pwController.text}),
      );

      var r = jsonDecode(response.body);
      var loginState = r["LoginState"];

      if (loginState) {
        Navigator.of(_dialogContext!)
            .pop(); // Use the captured context to close the dialog
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
      } else {
        Navigator.of(_dialogContext!)
            .pop(); // Use the captured context to close the dialog
        _showToast('로그인 실패');
      }
    } catch (e) {
      Navigator.of(_dialogContext!)
          .pop(); // Use the captured context to close the dialog
      print('오류: $e');
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 대화상자 바깥을 탭하여 닫을 수 없도록 설정
      builder: (BuildContext context) {
        _dialogContext = context; // 대화상자가 표시되는 컨텍스트를 캡처
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 24),
              Expanded(child: Text("로그인중입니다. 최초 1회 로그인 시 시간이 걸릴 수 있습니다."))
            ],
          ),
        );
      },
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
              child: const BezierContainer(),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  const SizedBox(height: 50),
                  _entryField("ID"),
                  _entryField("Password", isPassword: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isIdSaved,
                        onChanged: (bool? value) {
                          setState(() {
                            _isIdSaved = value ?? false;
                          });
                        },
                      ),
                      const Text('아이디 저장'),
                      Checkbox(
                        value: _keepLoggedIn,
                        onChanged: (bool? value) {
                          setState(() {
                            _keepLoggedIn = value ?? false;
                          });
                        },
                      ),
                      const Text('로그인 유지'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _submitButton(context),
                  _divider(),
                  SizedBox(height: height * .055),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return InkWell(
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
          '로그인',
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
}
