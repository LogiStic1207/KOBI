import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String _namenum = "";
  String _email = "";
  String _coursehistory = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('학생정보조회'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
<<<<<<< HEAD
                Text(
                  '학생정보',
                  style: TextStyle(color: Colors.blue),
=======
                ElevatedButton(
                  child: Text(
                    '기본',
                    style: TextStyle(
                      color: _showBasicInfo ? Colors.white : Colors.blue,
                    ),
                  ),
                  onPressed: () => setState(() => _showBasicInfo = true),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return _showBasicInfo ? Colors.blue : Colors.white;
                      },
                    ),
                    side: MaterialStateProperty.resolveWith<BorderSide>(
                      (Set<MaterialState> states) {
                        return BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        );
                      },
                    ),
                  ),
>>>>>>> c393d433840361e58a5dffa036be9ebeb9d9e5ea
                ),
              ],
            ),
          ),
          Expanded(
<<<<<<< HEAD
            child: _buildBasicInfo(),
=======
            child: _showBasicInfo
                ? _buildBasicInfo()
                : Center(child: Text('학생 정보가 없습니다')),
>>>>>>> c393d433840361e58a5dffa036be9ebeb9d9e5ea
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return ListView(
      children: <Widget>[
<<<<<<< HEAD
        Text(_namenum),
        Text(_email),
        Text(_coursehistory),
      ],
    );
  }


=======
        _buildTitleBar('학생기본정보'),
        _buildInfoBox('이름 (학번)', '홍길동 (2019136102)'),
        _buildInfoBox('학부(과)', '컴퓨터공학부'),
        _buildInfoBox('이메일', 'joon4555@koreatech.ac.kr'),
      ],
    );
  }
>>>>>>> c393d433840361e58a5dffa036be9ebeb9d9e5ea

  Widget _buildTitleBar(String title) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 2), // Top border
          bottom: BorderSide(color: Colors.black, width: 2), // Bottom border
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildInfoBox(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 238, 238, 238),
              border: Border.all(color: Colors.black38),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(content, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
