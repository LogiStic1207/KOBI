import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'options.dart';
import 'package:kobi_3/menu/mypage.dart';
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
  final List<String> categories = [
    '학부 선택',
    '스마트팩토리융합학과',
    'HRD학과',
    '강소기업경영학과',
    '고용서비스정책학과',
    '교양학부',
    '기계공학부',
    '기계설계공학과',
    '기전융합공학과',
    '디자인ㆍ건축공학부',
    '산업경영학부',
    '에너지신소재화학공학부',
    '융합학과',
    '전기ㆍ전자ㆍ통신공학부'
  ];
  String? _selectedCategory;
  Future<List<dynamic>>? _courses;
  static String getPostByID = r""" 
    query getCoursesByCategory($categoryId: String) {
      courses(categoryId: $categoryId){
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

  @override
  void initState() {
    super.initState();
    _selectedCategory = categories[0];
    //_courses = fetchCourses( _selectedCategory!);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // GraphQL 클라이언트를 안전하게 호출할 수 있는 위치
    if (_courses == null) { // 조건을 추가하여 불필요한 재호출 방지
      _courses = fetchCourses(_selectedCategory!);
    }
  }

  Future<List<dynamic>> fetchCourses(String categoryId) async {
    final client = GraphQLProvider.of(context).value;
    final QueryOptions options = QueryOptions(
      document: gql(getPostByID),
      variables: <String ,dynamic>{
        'categoryId': categoryId,
      }
    );
    final result = await client.query(options);
    if (result.hasException) {
      print(result.exception.toString());
      return [];
    }
    return result.data?['courses'] as List<dynamic>;
  }


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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              );
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
          DropdownButton<String>(
            value: _selectedCategory,
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue;
                _courses = fetchCourses(_selectedCategory!);
              });
            },
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(150, 50), backgroundColor: Colors.orange),
            onPressed: _selectedCategory == '학부 선택' ? null : () {
              setState(() {
                _courses = fetchCourses(_selectedCategory!);
              });
            },
            child: Text(
              '조회',
              style: TextStyle(fontWeight: FontWeight.w600),),
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
              body: _courses == null ? CircularProgressIndicator() : FutureBuilder<List<dynamic>>(
                future: _courses,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    //print("Error: ${snapshot.error}");
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final course = snapshot.data![index];
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            _resultBoxHeader(),
                            Text('${course['id']}'),
                            Text('${course['name']}'),
                            Text('${course['professor']}'),
                            Text('${course['grade']}'),
                            Text('${course['credit']}'),
                            Text('${course['type1']}'),
                            Text('${course['type2']}'),
                            Text('${course['targetDepartment']}'),
                            Text('${course['target']}'),
                            Text('${course['time']}'),
                            Text('${course['place']}'),
                            Text('${course['creditDetail']}'),
                            Text('${course['limit']}'),
                            Text('${course['timeData']}'),
                          ],)
                        );
                      },
                    );
                  } else {
                    return Text("No data found.");
                  }
                },
              ),
            ),
          ),
          Text('Step 2. 시간표 제작', style: TextStyle(fontWeight: FontWeight.w700)),
          Container(
              height: 150,
              decoration: BoxDecoration(color: Colors.brown),
              child: Text('장바구니')
          ), //장바구니
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(150, 50), backgroundColor: Colors.orange),
              onPressed: () {},
              child: Text(
                '제작',
                style: TextStyle(fontWeight: FontWeight.w600),
              )
          ),
        ]
      ),
    );
  }

}

class _resultBoxHeader extends StatelessWidget {
  const _resultBoxHeader ({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text('코드 및 분반'),
          Text('교과목명'),
          Text('담당교수'),
          Text('학년'),
          Text('학점'),
          Text('이수구분'),
          Text('강의구분'),
          Text('대상학부'),
          Text('대상'),
          Text('시간'),
          Text('장소'),
          Text('정원'),
          Text(' '),
        ],
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
        body: ListView(
          children: [
            _resultBoxHeader(),
          ],
        ),
      ),
    ); //제작 결과(경우의 수)
  }
  
}
*/