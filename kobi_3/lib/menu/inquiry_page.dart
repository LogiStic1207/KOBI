import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

class InquiryPage extends StatefulWidget {
  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inquiry"),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendEmail,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: 'Body'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }

  void _sendEmail() async {
    final mailtoLink = Mailto(
      to: ['jesper001207@gmail.com'], // Fixed recipient email
      subject: _subjectController.text,
      body: _bodyController.text,
    );

    await _launchURL(mailtoLink.toString());
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
      Fluttertoast.showToast(
        msg: "Email sent successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Could not launch email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
