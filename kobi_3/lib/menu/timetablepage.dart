import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Week Timetable',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TimetablePage(),
    );
  }
}

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final List<String> days = ['월', '화', '수', '목', '금'];
  final List<int> hours = List.generate(10, (index) => 9 + index);
  final PanelController _panelController = PanelController();
  String _selectedDepartment = '학부 선택';
  final TextEditingController _searchController = TextEditingController();
  final List<String> departments = [
    '학부 선택',
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

  List<Map<String, dynamic>> allCourses = [];
  List<Map<String, dynamic>> filteredCourses = [];
  List<Map<String, dynamic>> cartItems = [];
  bool _isLoading = false;

  final String query = r"""
    query getCourses($_selectedDepartment: String!) {
      courses(categoryId: $_selectedDepartment) {
        id name professor grade credit type1 type2 targetDepartment target
        time place creditDetail limit timeData
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('주간 시간표')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: buildTimeTable()),
              buildCart(),
            ],
          ),
          SlidingUpPanel(
            controller: _panelController,
            panel: buildSlidingPanel(),
            minHeight: 60,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            collapsed: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0)),
              ),
              child: Center(
                  child: Text('과목 검색 및 추가',
                      style: TextStyle(color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeTable() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          color: Colors.grey[200],
          child: Row(
            children: <Widget>[
              SizedBox(width: 64),
              ...days
                  .map((day) => Expanded(
                        child: Center(
                            child: Text(day,
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ))
                  .toList(),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
              columnWidths: {0: FixedColumnWidth(64)},
              children: hours
                  .map((hour) => TableRow(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.grey[100],
                            child: Text('${hour}시',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          ...days
                              .map((_) => TableCell(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        color: Colors.white,
                                      ),
                                      child: Text(''),
                                    ),
                                  ))
                              .toList(),
                        ],
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCart() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 16), // Reduced top margin
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 200, // Fixed height for the cart
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('장바구니',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child:
                        Text('장바구니에 과목이 없습니다.', style: TextStyle(fontSize: 14)))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      var course = cartItems[index];
                      return ListTile(
                        title: Text(course['name'],
                            style: TextStyle(fontSize: 14)),
                        subtitle: Text(
                            '${course['professor']} - ${course['time']}',
                            style: TextStyle(fontSize: 12)),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () => removeFromCart(course),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void performSearch() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredCourses = allCourses.where((course) {
        return course['name'].toLowerCase().contains(query) ||
            course['professor'].toLowerCase().contains(query);
      }).toList();
    });
  }

  Widget buildSlidingPanel() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            // This row contains the dropdown and search box and will not scroll.
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                      border: Border.all(color: Colors.grey) // Grey border
                      ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedDepartment,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                      onChanged: (String? newValue) {
                        if (newValue != null &&
                            newValue != _selectedDepartment) {
                          setState(() {
                            _selectedDepartment = newValue;
                            fetchCourses();
                          });
                        }
                      },
                      items: departments
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10), // Spacing between dropdown and text field
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: '과목 / 교수 검색',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: performSearch,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            // Only this part will scroll.
            child: !_isLoading
                ? ListView.builder(
                    itemCount: filteredCourses.isNotEmpty
                        ? filteredCourses.length
                        : allCourses.length,
                    itemBuilder: (context, index) {
                      var course = filteredCourses.isNotEmpty
                          ? filteredCourses[index]
                          : allCourses[index];
                      return ListTile(
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(course['name'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(width: 0.5), // Text 간의 공간
                            Expanded(
                              child: Text(course['id'],
                                  style: TextStyle(fontSize: 12)),
                            ),
                            SizedBox(width: 0.5), // Text 간의 공간
                            Expanded(
                              child: Text(course['professor'],
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(course['time'],
                                  style: TextStyle(fontSize: 10)),
                            ),
                            SizedBox(width: 4), // Text 간의 공간
                            Expanded(
                              child: Text("${course['grade']}학년",
                                  style: TextStyle(fontSize: 10)),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(isInCart(course)
                              ? Icons.remove_shopping_cart
                              : Icons.add_shopping_cart),
                          onPressed: () => isInCart(course)
                              ? removeFromCart(course)
                              : addToCart(course),
                        ),
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  void fetchCourses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var client = GraphQLProvider.of(context).value;
      var result = await client.query(
        QueryOptions(
          document: gql(query),
          variables: {'_selectedDepartment': _selectedDepartment},
        ),
      );

      if (result.hasException) {
        print(result.exception.toString());
        return;
      }

      setState(() {
        allCourses = List<Map<String, dynamic>>.from(result.data!['courses']);
        filteredCourses = [];
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool isInCart(Map<String, dynamic> course) {
    return cartItems.any((item) => item['id'] == course['id']);
  }

  void addToCart(Map<String, dynamic> course) {
    if (!isInCart(course)) {
      setState(() {
        cartItems.add(course);
      });
    }
  }

  void removeFromCart(Map<String, dynamic> course) {
    setState(() {
      cartItems.removeWhere((item) => item['id'] == course['id']);
    });
  }
}
