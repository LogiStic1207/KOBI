import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class apiCallscreen extends StatefulWidget {
  const apiCallscreen({super.key});

  @override
  State<apiCallscreen> createState() => _apiCallscreenState();
}

class _apiCallscreenState extends State<apiCallscreen> {
  List<dynamic> users = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rest API Call'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final email = user['email'];
          final imageUrl = user['picture']['thumbnail'];
          return ListTile(
            leading: Image.network(imageUrl),
            title: Text(email),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
      ),
    );
  }

  void fetchUsers() async {
    print('fetchUsers called');
    const url = 'https://randomuser.me/api/?results=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
        users = json['results'];
    });
    print('fetchUsers completed');
  }
}

