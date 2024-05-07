import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'options.dart';
import 'mypage.dart';
import 'package:kobi_3/chatbotpage.dart';

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
  final String query = r"""
    query get ($_selectedDepartment: String!) {
      courses(categoryId:$_selectedDepartment){
        id name professor grade credit type1 type2 targetDepartment target
        time place creditDetail limit timeData
      }
    }
  """;

  String _selectedDepartment = 'HRD학과';
  List<dynamic> allCourses = [];
  List<dynamic> filteredCourses = [];
  List<Map<String, dynamic>> cartItems = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('강의 조회 및 시간표 제작'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          Stack(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  _showCartDialog();
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '${cartItems.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          _buildDepartmentDropdown(),
          _buildQueryResultContainer(),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 65,
                  child: DrawerHeader(
                    child: Text('메뉴', style: TextStyle(color: Colors.white)),
                    decoration: BoxDecoration(color: Colors.blue),
                  ),
                ),
                ListTile(
                    title: Text('챗봇'),
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatBotPage()))),
                ListTile(
                    title: Text('설정'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OptionsPage()))),
                Divider(),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text(
                '로그아웃',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              onTap: () {
                // Logout logic goes here
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentDropdown() => DropdownButton(
      value: _selectedDepartment,
      items: _departmentList
          .map((value) =>
              DropdownMenuItem<String>(value: value, child: Text(value)))
          .toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() => _selectedDepartment = newValue);
        }
      });

  Widget _buildQueryResultContainer() => Expanded(
          child: Query(
        options: QueryOptions(
          document: gql(query),
          variables: {"_selectedDepartment": _selectedDepartment},
        ),
        builder: (result, {refetch, fetchMore}) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (result.isLoading && !_isLoading) {
              _setLoading(true);
            } else if (_isLoading) {
              _setLoading(false);
            }
          });

          if (result.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (result.hasException) {
            return Text('Error: ${result.exception.toString()}');
          } else if (result.data == null || result.data!["courses"] == null) {
            return Text('No courses available');
          }
          allCourses = List<Map<String, dynamic>>.from(result.data!["courses"]);
          return _buildCourseTable(allCourses);
        },
      ));

  void _setLoading(bool isLoading) {
    if (_isLoading != isLoading) {
      setState(() {
        _isLoading = isLoading;
      });
    }
  }

  Widget _buildCourseTable(List courses) {
    double screenHeight = MediaQuery.of(context).size.height; // 화면의 높이를 가져옴

    return Container(
      height: screenHeight / 2, // 컨테이너의 높이를 화면의 절반으로 설정
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              columns: _buildColumns(),
              rows: courses
                  .map((course) => _buildRow(course as Map<String, dynamic>))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
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
    ].map((header) => DataColumn(label: Text(header))).toList();
  }

  void addToCart(Map<String, dynamic> course) {
    setState(() {
      cartItems.add(course);
    });
  }

  void removeFromCart(Map<String, dynamic> course) {
    setState(() {
      cartItems.remove(course);
    });
  }

  bool isInCart(Map<String, dynamic> course) {
    // cartItems는 과목 리스트를 나타내는 변수입니다. 이 변수는 상위에 정의되어 있어야 합니다.
    return cartItems.contains(course);
  }

  DataRow _buildRow(Map<String, dynamic> course) => DataRow(cells: [
        DataCell(
          isInCart(course)
              ? IconButton(
                  icon: Icon(Icons.indeterminate_check_box, color: Colors.red),
                  onPressed: () => removeFromCart(course),
                )
              : IconButton(
                  icon: Icon(Icons.add_box, color: Colors.blue),
                  onPressed: () => addToCart(course),
                ),
        ),
        DataCell(Text(course['id'])),
        DataCell(Text(course['name'])),
        DataCell(Text(course['professor'])),
        DataCell(Text(course['grade'].toString())),
        DataCell(Text(course['credit'].toString())),
        DataCell(Text(course['type1'])),
        DataCell(Text(course['type2'])),
        DataCell(Text(course['targetDepartment'])),
        DataCell(Text(course['target'])),
        DataCell(Text(course['time'])),
        DataCell(Text(course['place'])),
        DataCell(Text(course['creditDetail'])),
        DataCell(Text(course['limit'].toString())),
      ]);

  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('장바구니'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${cartItems[index]['name']} ${cartItems[index]['id']}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog() {
    String searchQuery = ""; // 검색어를 저장할 변수
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Search Course'),
          content: TextField(
            onChanged: (value) {
              searchQuery = value; // 사용자가 입력한 값을 searchQuery에 저장
            },
            decoration: InputDecoration(
              hintText: "Enter course name",
            ),
          ),
          actions: [
            TextButton(
              child: Text('Search'), // 검색 버튼 추가
              onPressed: () {
                setState(() {
                  filteredCourses = allCourses
                      .where((course) => course['name']
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                      .toList();
                });
                Navigator.of(context).pop(); // 검색 후 다이얼로그 닫기
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
