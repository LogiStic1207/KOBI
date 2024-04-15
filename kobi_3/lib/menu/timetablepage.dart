import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'options.dart';

import '/chatbotpage.dart';
import 'package:flutter/material.dart';
//import './exception_handlers.dart';

class TimetablePage extends StatefulWidget {
  /*final String _storedId;
  final String _storedPw;
  final VoidCallback _resetLoginInfo;
  final Map<String, String> _headers;

  ChatBotPage(
      this._storedId, this._storedPw, this._resetLoginInfo, this._headers);*/
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final _departmentList = [
    '학부 선택',
    'HRD학과',
    '컴퓨터공학부',
    '디자인·건축공학부',
    '기계공학부',
    '전기·전자·통신공학부',
    '에너지신소재화학공학부',
    '산업경영학부',
    '메카트로닉스공학부',
    '고용서비스정책학과',
    '교양학부',
    '융합학과'
  ];
  final _rowsperPages = ['10', '20', '30', '50', '100'];
  var _selectedDepartment = '학부 선택';
  var _selectedRpp = '10';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("시간표 제작"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // 사용자 정보 페이지로 네비게이션 (추후 구현 필요)
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const SizedBox(
                    height: 100.0,
                    child: DrawerHeader(
                      child: Text('메뉴'),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('챗봇'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => ChatBotPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('설정'),
                    onTap: () {
                      // 설정 페이지로 네비게이션 (추후 구현 필요)
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OptionsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              height: 300,
              width: 300,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.black),
                  color: Colors.blue),
              child: Text('장바구니'),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(5.0),
        children: [
          Text('Step 1. 강의 조회', style: TextStyle(fontWeight: FontWeight.w700)),
          DropdownButton(
              value: _selectedDepartment,
              items: _departmentList.map(
                (value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value.toString();
                });
              }),
          ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: Size(150, 50), backgroundColor: Colors.orange), onPressed: () {}, child: Text('조회', style: TextStyle(fontWeight: FontWeight.w600),)),
          Container(
            height: 500,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                actions: [
                  SearchBar(
                    trailing: [
                      Icon(Icons.search),
                    ],
                    elevation: MaterialStatePropertyAll(0),
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    side: MaterialStatePropertyAll(BorderSide(color: Colors.blue, width: 2)),
                    constraints: BoxConstraints(maxWidth: 200),
                    //padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                    hintText: "결과 내 검색",
                    hintStyle: MaterialStatePropertyAll(TextStyle(color: Colors.grey.shade600)),
                  )
                ],
              ),
              body:SizedBox(),
              bottomNavigationBar: BottomAppBar(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('페이지 당 결과 수:', style: TextStyle(color: Colors.grey.shade400),),
                    DropdownButton(
                      value: _selectedRpp,
                      items: _rowsperPages.map(
                        (value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRpp = value.toString();
                      });
                    }),
                    Text('결과 인덱스(ex.1-20 of 55 )'),
                    IconButton(icon: Icon(Icons.arrow_back_rounded), onPressed: (){}),
                    IconButton(icon: Icon(Icons.arrow_forward_rounded), onPressed: (){}),
                  ],
                ),
              ),
            )
          ), //조회 결과
          Text('Step 2. 시간표 제작', style: TextStyle(fontWeight: FontWeight.w700)),
          Container(
              height: 150,
              decoration: BoxDecoration(color: Colors.brown),
              child: Text('장바구니')), //장바구니
          ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: Size(150, 50), backgroundColor: Colors.orange), onPressed: () {}, child: Text('제작', style: TextStyle(fontWeight: FontWeight.w600),)),
          Container(
            height: 500,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                actions: [
                  SearchBar(
                    trailing: [
                      Icon(Icons.search),
                    ],
                    elevation: MaterialStatePropertyAll(0),
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    side: MaterialStatePropertyAll(BorderSide(color: Colors.blue, width: 2)),
                    constraints: BoxConstraints(maxWidth: 200),
                    //padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                    hintText: "결과 내 검색",
                    hintStyle: MaterialStatePropertyAll(TextStyle(color: Colors.grey.shade600)),
                  )
                ],
              ),
              body:SizedBox(),
              bottomNavigationBar: BottomAppBar(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('페이지 당 결과 수:', style: TextStyle(color: Colors.grey.shade400),),
                    DropdownButton(
                      value: _selectedRpp,
                      items: _rowsperPages.map(
                        (value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRpp = value.toString();
                      });
                    }),
                    Text('결과 인덱스(ex.1-20 of 55 )'),
                    IconButton(icon: Icon(Icons.arrow_back_rounded), onPressed: (){}),
                    IconButton(icon: Icon(Icons.arrow_forward_rounded), onPressed: (){}),
                  ],
                ),
              ),
            )
          ), //제작 결과(경우의 수)
        ],
      ),
    );
  }
}

