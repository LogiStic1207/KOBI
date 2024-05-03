import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'options.dart';
import 'package:kobi_3/menu/mypage.dart';
import '/chatbotpage.dart';
import 'package:flutter/material.dart';

//import './exception_handlers.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final List<String> _departmentList = [
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
  final List<String> _headers = [
    '추가/삭제',
    '코드 및 분반',
    '교과목명',
    '담당교수',
    '학년',
    '학점',
    '이수구분',
    '강의구분',
    '대상학부',
    '대상',
    '시간',
    '장소',
    '학강실설',
    '정원'
  ];
  final List<String> _keys = [
    'id',
    'name',
    'professor',
    'grade',
    'credit',
    'type1',
    'type2',
    'targetDepartment',
    'target',
    'time',
    'place',
    'creditDetail',
    'limit'
  ];

  String _selectedDepartment = 'HRD학과';

  String query = r"""
        query get ($_selectedDepartment: String!) {
          courses(categoryId:$_selectedDepartment){
            id
            name
            professor
            grade
            credit
            type1
            type2
            targetDepartment
            target
            time
            place
            creditDetail
            limit
            timeData
          }
        }
    """;
  bool isPressed = false;
  final double tableWidth = 75; //테이블 너비

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(),
      body: ListView(
        padding: EdgeInsets.all(5.0),
        children: [
          Text('Step 1. 강의 조회', style: TextStyle(fontWeight: FontWeight.w700)),
          DropdownButton(
              value: _selectedDepartment,
              items: _departmentList.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue != null) {
                    _selectedDepartment = newValue;
                  }
                });
              }),
          ElevatedButton(
            onPressed: () async {},
            child: Text('조회'),
          ),
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
                        side: MaterialStatePropertyAll(
                            BorderSide(color: Colors.blue, width: 2)),
                        constraints: BoxConstraints(maxWidth: 200),
                        //padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                        hintText: "결과 내 검색",
                        hintStyle: MaterialStatePropertyAll(
                            TextStyle(color: Colors.grey.shade600)),
                      )
                    ],
                  ),
                  body: Query(
                      options: QueryOptions(
                        document: gql(query),
                        variables: <String, dynamic>{
                          "_selectedDepartment": _selectedDepartment,
                        },
                      ),
                      builder: (QueryResult result,
                          {VoidCallback? refetch, FetchMore? fetchMore}) {
                        //if (result.hasException) {
                        //  return Text(result.exception.toString());
                        //}
                        if (result.isLoading) {
                          return CircularProgressIndicator();
                        }
                        if (result.data == null ||
                            result.data!["courses"] == null) {
                          return Text('No courses available');
                        }

                        List courses = result.data!["courses"];

                        return Column(
                          children: [
                            Container(
                                padding: EdgeInsets.all(7.0),
                                height: 50,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(14, (index) => Container(
                                      width: tableWidth,
                                      alignment: Alignment.center,
                                      child: Text(_headers[index], style: TextStyle(fontWeight: FontWeight.w700),),
                                    )),
                                  ),
                                ),
                            ),

                            Expanded(
                              child: ListView.builder(
                                itemCount: courses.length,
                                itemBuilder: (context, index) {
                              
                                  Map course = courses[index];
                                  return ListTile(
                                    
                                    leading: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              isPressed ? Colors.red : Colors.blue,
                                          foregroundColor: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          isPressed = !isPressed;
                                        });
                                      },
                                      child: Text(isPressed ? '삭제' : '추가'),
                                    ),
                                    /*
                                    title: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(14, (key) => Container(
                                          width: tableWidth,
                                          alignment: Alignment.centerLeft,
                                          child: Text(course[key]),
                                        )),
                              
                                      ),
                                    )*/
                                    title: SingleChildScrollView(
                                      child: Row(
                                        children: [
                                          Text(course["id"]),
                                          Text(course["name"]),
                                          Text(course["professor"]),
                                          Text(course["grade"]),
                                          Text(course["credit"]),
                                          Text(course["type1"]),
                                          Text(course["type2"]),
                                          Text(course["targetDepartment"]),
                                          Text(course["target"]),
                                          Text(course["time"]),
                                          Text(course["place"]),
                                          Text(course["creditDetail"]),
                                          Text(course["limit"]),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ],
                        );
                      }),
              )
          ), //조회 결과
          Text('Step 2. 시간표 제작', style: TextStyle(fontWeight: FontWeight.w700)),
          Container(
              height: 150,
              decoration: BoxDecoration(color: Colors.brown),
              child: Text('장바구니')), //장바구니
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50), backgroundColor: Colors.orange),
              onPressed: () {},
              child: Text(
                '제작',
                style: TextStyle(fontWeight: FontWeight.w600),
              )),
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
                      side: MaterialStatePropertyAll(
                          BorderSide(color: Colors.blue, width: 2)),
                      constraints: BoxConstraints(maxWidth: 200),
                      //padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                      hintText: "결과 내 검색",
                      hintStyle: MaterialStatePropertyAll(
                          TextStyle(color: Colors.grey.shade600)),
                    )
                  ],
                ),
                body: SizedBox(),
                bottomNavigationBar: BottomAppBar(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '페이지 당 결과 수:',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text('결과 인덱스(ex.1-20 of 55 )'),
                      IconButton(
                          icon: Icon(Icons.arrow_back_rounded),
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.arrow_forward_rounded),
                          onPressed: () {}),
                    ],
                  ),
                ),
              )), //제작 결과(경우의 수)
        ],
      ),
    );
  }
}

class _headResultSearch extends StatefulWidget {
  @override
  _headResultSearchState createState() => _headResultSearchState();
}

//const _headResultSearch({super.key});
class _headResultSearchState extends State<_headResultSearch> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: isPressed ? Colors.red : Colors.blue,
            foregroundColor: Colors.white),
        onPressed: () {
          setState(() {
            isPressed = !isPressed;
          });
        },
        child: Text(isPressed ? '삭제' : '추가'),
      ),
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Expanded(
                child: Text(
              '추가/삭제',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '코드 및 분반',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '교과목명',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '담당교수',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '학년',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '학점',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '이수구분',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '강의구분',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '대상학부',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '대상',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '시간',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '장소',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '학강실설',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
            Expanded(
                child: Text(
              '정원',
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
          ],
        ),
      ),
    );
  }
}

/*
class _resultBox extends StatelessWidget {
  const _resultBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                side: MaterialStatePropertyAll(
                    BorderSide(color: Colors.blue, width: 2)),
                constraints: BoxConstraints(maxWidth: 200),
                //padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
                hintText: "결과 내 검색",
                hintStyle: MaterialStatePropertyAll(
                    TextStyle(color: Colors.grey.shade600)),
              )
            ],
          ),
          body:           Container(
            height: 500,
            decoration: BoxDecoration(color: Colors.blue),
            child: Query(
              options: QueryOptions(
                document: gql(query),
                variables: <String, dynamic>{
                  "_selectedDepartment": _selectedDepartment,
                },
              ),
              builder: (QueryResult result,
                  {VoidCallback? refetch, FetchMore? fetchMore}) {
                //if (result.hasException) {
                //  return Text(result.exception.toString());
                //}
                if (result.isLoading) {
                  return CircularProgressIndicator();
                }
                if (result.data == null || result.data!["courses"] == null) {
                  return Text('No courses available');
                }
                //List? courses = result.data?["courses"];
                //return Text(courses?[0]);
                List courses = result.data!["courses"];

                return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      Map course = courses[index];
                      return ListTile(title: Text(course["name"] ?? 'No name'));
                    });
              },
            ),
          ), //조회 결과
          bottomNavigationBar: BottomAppBar(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '페이지 당 결과 수:',
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                Text('결과 인덱스(ex.1-20 of 55 )'),
                IconButton(
                    icon: Icon(Icons.arrow_back_rounded), onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.arrow_forward_rounded), onPressed: () {}),
              ],
            ),
          ),
        )); //제작 결과(경우의 수);
  }
}
*/
