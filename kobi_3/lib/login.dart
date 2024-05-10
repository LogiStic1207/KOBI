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

  Future<void> _sendInfotoServer() async {
    //final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = _idController.text;
      userPw = _pwController.text;
    });
    Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatBotPage()));

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
                        onPressed: _sendInfotoServer,
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
