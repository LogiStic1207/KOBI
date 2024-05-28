import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  Map<String, List<String>> departmentCodes = {
    '기계공학부': ['MEE', 'MEG', 'MEF', 'MES', 'MEC', 'MEB', 'MEA'],
    '메카트로닉스공학부': ['MTC', 'MTB', 'MTA', 'MCA', 'CCT', 'MTS'],
    '전기ㆍ전자ㆍ통신공학부': ['IFA', 'IFB', 'IFC', 'IFE'],
    '컴퓨터공학부': ['CSE'],
    '디자인ㆍ건축공학부': ['IDA', 'ARB', 'ARD', 'ARE'],
    '에너지신소재화학공학부': ['CHA', 'MSA'],
    '산업경영학부': ['IMA', 'IMC', 'IMB'],
    '고용서비스정책학과': ['ESP'],
    '교양학부': ['SHA', 'SHB', 'KMC', 'CON', 'NAT', 'LAN', 'IME'],
    'HRD학과': ['EDU', 'HRD'],
    '융합학과': ['CVG']
  };

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
      appBar: AppBar(
        title: Text('주간 시간표'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveTimetable,
          ),
          IconButton(
            icon: Icon(Icons.folder_open),
            onPressed: loadTimetable,
          ),
          IconButton(
            icon: Icon(Icons.recommend),
            onPressed: () async {
              showRecommendationDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 시간표 부분을 화면의 80% 크기로 설정
          Expanded(
            flex: 6, // 8:2 비율로 시간표와 장바구니 공간을 나눔
            child: buildTimeTable(),
          ),
          // 장바구니를 화면의 20% 크기로 설정
          Expanded(
            flex: 3,
            child: buildCart(),
          ),
          // 슬라이딩 패널
          SlidingUpPanel(
            controller: _panelController,
            panel: buildSlidingPanel(),
            minHeight: 60,
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            collapsed: Container(
              decoration: BoxDecoration(
                color: Color(0xff30619c),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              child: Center(
                child:
                    Text('과목 검색 및 추가', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showRecommendationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('과목 추천'),
          content: FutureBuilder<List<String>>(
            future: _recommendTest(context),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('오류가 발생했습니다: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('추천 과목이 없습니다.');
              } else {
                // 데이터가 있을 경우 10개로 제한
                List<String> recommendations = snapshot.data!.take(10).toList();
                return Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: recommendations.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          recommendations[index],
                          style: TextStyle(fontSize: 12), // 원하는 글자 크기로 변경
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            Navigator.of(context).pop(); // 추천 창 닫기
                            String courseCode =
                                recommendations[index].split(' | ')[0];
                            String courseName =
                                recommendations[index].split(' | ')[1];
                            String department = departmentCodes.keys.firstWhere(
                              (key) => departmentCodes[key]!
                                  .any((code) => courseCode.startsWith(code)),
                              orElse: () => '학부 선택',
                            );

                            // 학부 선택
                            setState(() {
                              _selectedDepartment = department;
                            });

                            // 패널 열기 및 과목 로드
                            _panelController.open();
                            await fetchCourses();

                            // 과목명 설정 후 검색 수행
                            setState(() {
                              _searchController.text = courseName;
                            });

                            // 검색 수행
                            performSearch();
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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

  // _recommendTest 함수가 Future<List<String>>을 반환하도록 수정
  Future<List<String>> _recommendTest(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recommendations = [];
    try {
      var response = await _recommendRequest(prefs.getString('lastLoggedInId'));
      var recommend_list = jsonDecode(response.body)["recommend"];
      if (response.statusCode == 200) {
        recommendations = List<String>.from(recommend_list);
      }
    } catch (e) {
      print('오류: $e');
    }
    return recommendations;
  }

  Future<http.Response> _recommendRequest(String? currentId) {
    var url = 'http://211.57.218.130:37627/recommend';
    return http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"recommend": ""}),
    );
  }

  Map<String, List<RangeValues>> parseCourseTime(String timeString) {
    RegExp exp = RegExp(r"([월화수목금])(\d{2})A~(\d{2})B");
    Iterable<RegExpMatch> matches = exp.allMatches(timeString);
    Map<String, List<RangeValues>> schedule = {};

    for (var match in matches) {
      String day = match.group(1)!; // 요일
      int startHour = int.parse(match.group(2)!) - 1; // 시작 시간
      int endHour = int.parse(match.group(3)!); // 종료 시간

      // null 검사 후 리스트에 시간 범위 추가
      (schedule[day] ??= []).add(RangeValues(9.0 + startHour, 9.0 + endHour));
    }
    return schedule;
  }

  Map<String, Color> courseColors = {};
  List<Color> availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.amber,
    Colors.teal
  ];

  Color getColorForCourse(String courseId) {
    return courseColors.putIfAbsent(courseId,
        () => availableColors[Random().nextInt(availableColors.length)]);
  }

  Widget buildTimeTable() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 1),
          color: Colors.grey[200],
          child: Row(
            children: <Widget>[
              SizedBox(width: 64), // 첫 번째 열은 시간을 표시
              ...days.map((day) => Expanded(
                    child: Center(
                        child: Text(day,
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ))
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
                              .map((day) => buildTimeTableCell(day, hour))
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

  Widget buildTimeTableCell(String day, int hour) {
    List<Map<String, dynamic>> overlappingCourses = [];
    bool showCourseInfo = false;

    for (var course in cartItems) {
      Map<String, List<RangeValues>> courseTimes = course['parsedTime'];
      if (courseTimes.containsKey(day) && courseTimes[day] != null) {
        for (var range in courseTimes[day]!) {
          if (hour >= range.start && hour < range.end) {
            overlappingCourses.add(course);
            int middleHour = ((range.start + range.end) / 2).floor();
            if (hour == middleHour) {
              showCourseInfo = true;
            }
          }
        }
      }
    }

    return TableCell(
      child: Container(
        height: 40, // 고정된 높이를 크게 설정
        padding: EdgeInsets.all(4), // 패딩을 줄임
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: overlappingCourses.isNotEmpty
              ? overlappingCourses.first['color']
              : Colors.white,
        ),
        child: overlappingCourses.isNotEmpty && showCourseInfo
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // 수직 중앙 정렬
                children: [
                  Text(
                    overlappingCourses.first['name'],
                    style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold), // 폰트 크기를 줄임
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    overlappingCourses.first['professor'],
                    style: TextStyle(
                        fontSize: 9, color: Colors.grey[800]), // 폰트 크기를 줄임
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget buildCart() {
    int totalCredits = cartItems.fold(
        0, (sum, item) => sum + int.parse(item['credit'] ?? '0'));

    return Container(
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8), // Reduced top margin
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
          Text('장바구니 - 총 학점: $totalCredits',
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

  Widget buildSlidingPanel() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
                        title: Text('${course['name']} (${course['id']})'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('교수: ${course['professor']}'),
                            Row(children: [
                              Text(
                                '시간: ${course['time']}   ${course['grade']}학년   ${course['credit']}학점',
                                style: TextStyle(
                                  fontSize: 10.9, // 폰트 크기
                                  color: Colors.grey[800], // 글자 색상
                                ),
                              ),
                            ])
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(isInCart(course)
                              ? Icons.remove_shopping_cart
                              : Icons.add_shopping_cart),
                          onPressed: () {
                            if (isInCart(course)) {
                              removeFromCart(course);
                            } else {
                              addToCart(context, course);
                            }
                          },
                        ),
                        isThreeLine: true,
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  Future<void> fetchCourses() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await _load_selected_lecturedata();
      final data = json.decode(response.body);

      setState(() {
        allCourses = List<Map<String, dynamic>>.from(data['courses']);
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

  Future<http.Response> _load_selected_lecturedata() {
    var url = 'http://211.57.218.130:37627/load';
    return http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'selectedDepartment': _selectedDepartment}),
    );
  }

  bool isInCart(Map<String, dynamic> course) {
    return cartItems.any((item) => item['id'] == course['id']);
  }

  void addToCart(BuildContext context, Map<String, dynamic> course) {
    // 겹침 검사
    bool hasOverlap = cartItems.any((existingCourse) {
      Map<String, List<RangeValues>> existingTimes =
          existingCourse['parsedTime'];
      Map<String, List<RangeValues>> newCourseTimes =
          parseCourseTime(course['time']);
      return existingTimes.keys.any((day) =>
          newCourseTimes[day]?.any((newRange) =>
              existingTimes[day]?.any((existingRange) =>
                  newRange.start < existingRange.end &&
                  newRange.end > existingRange.start) ??
              false) ??
          false);
    });

    if (hasOverlap) {
      // 다이얼로그 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('경고'),
            content: Text('추가하려는 과목의 시간이 이미 있는 과목과 겹칩니다.'),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              )
            ],
          );
        },
      );
    } else {
      setState(() {
        cartItems.add(course);
        course['parsedTime'] = parseCourseTime(course['time']);
        course['color'] = getColorForCourse(course['id']);
      });
    }
  }

  void removeFromCart(Map<String, dynamic> course) {
    setState(() {
      cartItems.removeWhere((item) => item['id'] == course['id']);
    });
  }

  void saveTimetable() async {
    TextEditingController nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('시간표 저장'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "시간표 이름을 입력하세요"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('저장'),
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  List<Map<String, dynamic>> cartItemsToSave =
                      cartItems.map((course) {
                    return {
                      'id': course['id'],
                      'name': course['name'],
                      'professor': course['professor'],
                      'time': course['time'],
                      'parsedTime': course['parsedTime'].map((day, time) {
                        return MapEntry(
                          day,
                          time
                              .map((range) =>
                                  {'start': range.start, 'end': range.end})
                              .toList(),
                        );
                      }),
                      'color': course['color'].value,
                      'credit': course['credit'],
                    };
                  }).toList();

                  int totalCredits = cartItems.fold(
                      0, (sum, item) => sum + int.parse(item['credit'] ?? '0'));

                  Map<String, dynamic> timetableData = {
                    'cartItems': cartItemsToSave,
                    'totalCredits': totalCredits,
                  };

                  String timetableJson = jsonEncode(timetableData);
                  await prefs.setString(
                      "timetable_${nameController.text}", timetableJson);

                  if (mounted) {
                    Navigator.of(context).pop(); // 창 닫기

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('시간표가 저장되었습니다.')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void loadTimetable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    List<String> timetableNames =
        keys.where((key) => key.startsWith("timetable_")).toList();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              title: Text('시간표 불러오기'),
              content: Container(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: timetableNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    String timetableName = timetableNames[index]
                        .substring(10); // "timetable_" 부분 제거
                    return ListTile(
                      title: Text(timetableName),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await prefs.remove(timetableNames[index]);
                          dialogSetState(() {
                            timetableNames.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('$timetableName 시간표가 삭제되었습니다.')),
                          );
                        },
                      ),
                      onTap: () async {
                        String? timetableJson =
                            prefs.getString(timetableNames[index]);
                        if (timetableJson != null) {
                          Map<String, dynamic> timetableData =
                              jsonDecode(timetableJson);
                          List<Map<String, dynamic>> loadedCartItems =
                              List<Map<String, dynamic>>.from(
                                  timetableData['cartItems'].map((courseJson) {
                            Map<String, dynamic> course =
                                Map<String, dynamic>.from(courseJson);
                            course['parsedTime'] =
                                (course['parsedTime'] as Map<String, dynamic>)
                                    .map((day, times) {
                              return MapEntry(
                                day,
                                (times as List<dynamic>).map((range) {
                                  return RangeValues(
                                    range['start']?.toDouble() ?? 0.0,
                                    range['end']?.toDouble() ?? 0.0,
                                  );
                                }).toList(),
                              );
                            });
                            course['color'] = Color(course['color']);
                            course['credit'] =
                                course['credit'] ?? '0'; // 기본 값 보장
                            return course;
                          }).toList());

                          int loadedTotalCredits =
                              timetableData['totalCredits'];

                          // 부모 위젯의 상태 업데이트
                          setState(() {
                            cartItems = loadedCartItems;
                            // 필요한 경우 다른 상태 변수도 여기서 업데이트
                          });

                          Navigator.of(context).pop(); // 다이얼로그 닫기

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '시간표가 로드되었습니다. 총 학점: $loadedTotalCredits')),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('닫기'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
