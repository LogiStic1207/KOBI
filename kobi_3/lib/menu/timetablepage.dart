import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'options.dart';
import 'package:kobi_3/chatbotpage.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final List<String> _departmentList = [
    '학과 선택',
    '기계공학부',
    '메카트로닉스공학부',
    '전기ㆍ전자ㆍ통신공학부',
    '컴퓨터공학부',
    '디자인ㆍ건축공학부',
    '에너지신소재화학공학부',
    '산업경영학부',
    '고용서비스정책학과',
    '교양학부',
    'HRD학과',
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

  String _selectedDepartment = '학과 선택';
  List<Map<String, dynamic>> allCourses = [];
  List<Map<String, dynamic>> filteredCourses = [];
  List<Map<String, dynamic>> cartItems = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KOBI : 시간표 제작'),
        actions: [
          Stack(
            children: <Widget>[
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
          _buildDepartmentDropdownAndQueryButton(),
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
                _buildCartContainer(), // Call to build the cart container
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

  Widget _buildCartContainer() {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '장바구니',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(cartItems[index]['name']),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      cartItems.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentDropdownAndQueryButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IntrinsicWidth(
          // This widget forces its child to have a width that fits its content
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: false, // Set to false to fit content
                value: _selectedDepartment,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                iconEnabledColor: Colors.black,
                items: _departmentList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedDepartment = newValue);
                  }
                },
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_selectedDepartment != '학과 선택') {
              fetchCourses();
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("경고"),
                    content: Text("과목을 선택해주세요."),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Text('조회'),
        ),
      ],
    );
  }

  void fetchCourses() {
    setState(() {
      _isLoading = true;
    });
  }

  Widget _buildQueryResultContainer() {
    return Expanded(
      child: _isLoading
          ? Query(
              options: QueryOptions(
                document: gql(query),
                variables: {"_selectedDepartment": _selectedDepartment},
                fetchPolicy: FetchPolicy.noCache,
              ),
              builder: (result, {refetch, fetchMore}) {
                if (result.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (result.hasException) {
                  return Text('Error: ${result.exception.toString()}');
                } else if (result.data == null ||
                    result.data!["courses"] == null) {
                  return Text('No courses available');
                }
                allCourses =
                    List<Map<String, dynamic>>.from(result.data!["courses"]);
                return _buildCourseTable(allCourses);
              },
            )
          : Center(
              child:
                  Text("Select a department and click '조회' to fetch courses.")),
    );
  }

  Widget _buildCourseTable(List courses) {
    double screenHeight = MediaQuery.of(context).size.height;
    UniqueKey tableKey = UniqueKey();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Courses',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    filteredCourses = allCourses
                        .where((course) => course['name']
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                        .toList();
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            key: tableKey, // 위젯에 새로운 키 할당
            height: screenHeight / 3,
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
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: _buildColumns(),
                        rows:
                            courses.map((course) => _buildRow(course)).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1, // Takes 1/3 of the available space
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: 8),
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
            child: Column(
              children: [
                Text('과목 장바구니',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            '${cartItems[index]['name']} ${cartItems[index]['id']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              cartItems.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
      '강의구분',
      '시간',
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
      cartItems.remove(course); // 장바구니 목록에서 해당 과목을 제거
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
        DataCell(Text(course['time'])),
        DataCell(Text(course['creditDetail'])),
        DataCell(Text(course['limit'].toString())),
      ]);
}
