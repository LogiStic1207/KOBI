import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'chatbotpage.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final _isObscure = ValueNotifier<bool>(true);
  final _isLoading = ValueNotifier<bool>(false);
  String? userId;
  String? userPw;

  @override
  void initState() {
    super.initState();
    //_loadLoginInfo();
  }

  Future<void> _loadLoginInfo() async {
    //final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = _idController.text;
      userPw = _pwController.text;
    });
    //_idController.text = prefs.getString('userId') ?? '';
    //_pwController.text = prefs.getString('userPw') ?? '';
    if (_idController.text.isNotEmpty && _pwController.text.isNotEmpty) {
      print(userId);
      print(userPw);
      login(userId, userPw);
    }
  }

  Future<void> login(String? userId, String? userPwd) async {
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };

    var body =
        'anchor=&id=EL2&RelayState=%2Flocal%2Fsso%2Findex.php&user_id=june573166&user_password=rlaalswns9%21';
    var url = 'https://tsso.koreatech.ac.kr/svc/tk/Login.do';

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
    print('시도 1.');
    print(response.statusCode);
    url = response.headers['location'] ?? '';
    if (url.isNotEmpty) {
      response = await http.get(Uri.parse(url), headers: headers);
    }
    print('리디렉션 후 시도1');
    print(response.statusCode);

    url = response.headers['location'] ?? '';
    if (url.isNotEmpty) {
      response = await http.get(Uri.parse(url), headers: headers);
    }
    print('리디렉션 후 시도2');
    print(response.statusCode);
    url = response.headers['location'] ?? '';
    if (url.isNotEmpty) {
      response = await http.get(Uri.parse(url), headers: headers);
    }
    print('리디렉션 후 시도3');
    if (response.statusCode == 200) {
      print('로그인 성공!');
    } else {
      print('로그인 실패ㅠㅠ');
    }

    // 후속 요청...
    // Dart에서는 `setCookieSync` 같은 직접적인 쿠키 관리 함수가 없습니다. 서버 응답에 따라 쿠키를 관리해야 합니다.
  }

  Future<void> _loginRequest() async {
    _isLoading.value = true;
    var url = "https://tsso.koreatech.ac.kr/svc/tk/Login.do";
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'user_id': _idController.text,
        'user_pwd': _pwController.text,
        'RelayState': '/index.jsp',
        'id': 'PORTAL',
        'targetId': 'PORTAL',
      },
    ).timeout(const Duration(seconds: 5));

    _isLoading.value = false;
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      if (response.body.contains('alert')) {
        _showToast('로그인 실패. ID/PW를 확인해주세요');
      } else {
        _showToast('로그인 성공');
        await prefs.setString('userId', _idController.text);
        await prefs.setString('userPw', _pwController.text);
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => ChatBotPage()));
      }
    } else {
      _showToast('서버 오류로 로그인 실패');
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Widget _buildTextField(String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isObscure.value : false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          contentPadding: const EdgeInsets.all(10),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_isObscure.value
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () => _isObscure.value = !_isObscure.value,
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', width: 250, height: 200),
              const SizedBox(height: 20),
              const Text('KOBI: 코리아텍 비서',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              _buildTextField('ID', _idController),
              _buildTextField('Password', _pwController, isPassword: true),
              const SizedBox(height: 20),
              ValueListenableBuilder<bool>(
                valueListenable: _isLoading,
                builder: (_, isLoading, __) => isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _loadLoginInfo,
                        child: const Text('로그인',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
