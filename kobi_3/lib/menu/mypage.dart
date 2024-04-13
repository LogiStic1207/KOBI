import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool _showBasicInfo = true; // Assuming 'Basic' is the default tab

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
                ElevatedButton(
                  child: Text('기본'),
                  onPressed: () => setState(() => _showBasicInfo = true),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return _showBasicInfo ? Colors.blue : Colors.white;
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  child: Text('성적'),
                  onPressed: () => setState(() => _showBasicInfo = false),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return _showBasicInfo ? Colors.white : Colors.blue;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _showBasicInfo ? _buildBasicInfo() : _buildGradesInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return ListView(
      children: <Widget>[
        _buildTitleBar('학생기본정보'),
        _buildInfoBox('이름 (학번)', '홍길동 (2019136102)'),
        _buildInfoBox('학년, 성별, 학적상태', '4, 남자, 재학'),
        _buildInfoBox('학부(과)', '컴퓨터공학부'),
      ],
    );
  }

  Widget _buildGradesInfo() {
    return ListView(
      children: <Widget>[
        _buildTitleBar('성적정보'),
        _buildInfoBox('2019-1학기', '신청 : 16, 이수: 16, 평점: 2.97'),
      ],
    );
  }

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
