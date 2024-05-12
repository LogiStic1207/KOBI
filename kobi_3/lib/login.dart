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
  String userId = "";
  String userPw = "";

  @override
  void initState() {
    super.initState();
    //_loadLoginInfo();
  }

  Future<void> _sendInfotoServer() async {
    setState(() {
      _isLoading.value = true; // 로딩 상태 표시
    });

    try {
      var url = 'http://192.168.0.13:5000/login';
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': _idController.text, 'pw': _pwController.text}),
      );

      var r = jsonDecode(response.body);
      var loginState = r["LoginState"];

      if (loginState) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
      } else {
        // 로그인 실패 UI 처리
        print('로그인 실패');
      }
    } catch (e) {
      print('오류: $e');
      // 사용자 친화적인 오류 메시지를 표시하여 예외 처리
    } finally {
      setState(() {
        _isLoading.value = false; // 로딩 상태 초기화
      });
    }
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      ),
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
