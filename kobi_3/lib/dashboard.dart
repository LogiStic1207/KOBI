import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kobi_3/menu/timetablepage.dart';
import 'menu/inquiry_page.dart';
import 'menu/mypage.dart';
import 'menu/options.dart';
import 'chatbotpage.dart';
import 'style/styles.dart';
import 'package:kobi_3/login.dart';
import 'package:kobi_3/menu/shuttlecitychoose.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Gordita',
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedTab = 'All';
  int chatBotCount = 0;
  int timetableCount = 0;
  int busInfoCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      chatBotCount = prefs.getInt('chatBotCount') ?? 0;
      timetableCount = prefs.getInt('timetableCount') ?? 0;
      busInfoCount = prefs.getInt('busInfoCount') ?? 0;
    });
  }

  Future<void> _incrementCount(String card) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (card == 'ChatBot') {
        chatBotCount++;
        prefs.setInt('chatBotCount', chatBotCount);
      } else if (card == 'Timetable') {
        timetableCount++;
        prefs.setInt('timetableCount', timetableCount);
      } else if (card == 'BusInfo') {
        busInfoCount++;
        prefs.setInt('busInfoCount', busInfoCount);
      }
    });
  }

  List<Widget> _getFilteredCards() {
    List<Widget> cards = [];
    double speechBubbleTop =
        selectedTab == 'Favourite' ? 60 : 2; // Favourite일 때 speechBubble 위치 조정
    if (selectedTab == 'All' || selectedTab == 'Recommended') {
      cards.add(ChatBotCard(
          onTap: () => _incrementCount('ChatBot'),
          speechBubbleTop: speechBubbleTop));
      cards.add(const SizedBox(height: 60));
      cards.add(TimetableCard(onTap: () => _incrementCount('Timetable')));
      cards.add(const SizedBox(height: 60));
      cards.add(BusInfoCard(onTap: () => _incrementCount('BusInfo')));
    }
    if (selectedTab == 'Favourite') {
      if (chatBotCount >= timetableCount && chatBotCount >= busInfoCount) {
        cards.add(ChatBotCard(
            onTap: () => _incrementCount('ChatBot'),
            speechBubbleTop: speechBubbleTop));
      } else if (timetableCount >= chatBotCount &&
          timetableCount >= busInfoCount) {
        cards.add(TimetableCard(
            onTap: () => _incrementCount('Timetable'),
            speechBubbleTop: speechBubbleTop));
      } else if (busInfoCount >= chatBotCount &&
          busInfoCount >= timetableCount) {
        cards.add(BusInfoCard(
            onTap: () => _incrementCount('BusInfo'),
            speechBubbleTop: speechBubbleTop));
      }
    }
    return cards;
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedId');
    await prefs.remove('savedPassword');
    await prefs.remove('isIdSaved');
    await prefs.remove('keepLoggedIn');
    await prefs.remove('loginCount');
    await prefs.remove('lastLoggedInId');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('로그아웃 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await _logout(context);
              },
              child: const Text('예'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 알림창 닫기
              },
              child: const Text('아니오'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 65, // 여기서 높이를 원하는 값으로 설정
              decoration: BoxDecoration(
                color: Color(0xff30619c),
              ),
              child: Center(
                child: Text(
                  '메뉴',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('내 정보'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyPage()), //mypage로 변경해야함!!
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_support),
              title: Text('문의하기'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InquiryPage()),
                );
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Color(0xff30619c),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _showLogoutConfirmationDialog(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Logout'),
                          SizedBox(width: 10),
                          Icon(Icons.logout),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.settings),
                    color: Color(0xff30619c),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OptionsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
              height: size.height / 4,
              width: size.width,
              decoration: const BoxDecoration(
                color: Color(0xff30619c),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          'KO : BI',
                          style: AppStyle.b32w,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '코리아텍 비서',
                          style: AppStyle.r12w,
                        ),
                      ],
                    ),
                    Builder(
                      builder: (context) => IconButton(
                        icon: Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              height: size.height - (size.height / 5),
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(34),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 'All';
                          });
                        },
                        child: Text(
                          'All',
                          style: selectedTab == 'All'
                              ? AppStyle.m12b.copyWith(
                                  decoration: TextDecoration.underline)
                              : AppStyle.m12bt,
                        ),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 'Favourite';
                          });
                        },
                        child: Text(
                          'Favourite',
                          style: selectedTab == 'Favourite'
                              ? AppStyle.m12b.copyWith(
                                  decoration: TextDecoration.underline)
                              : AppStyle.m12bt,
                        ),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 'Recommended';
                          });
                        },
                        child: Text(
                          'Recommended',
                          style: selectedTab == 'Recommended'
                              ? AppStyle.m12b.copyWith(
                                  decoration: TextDecoration.underline)
                              : AppStyle.m12bt,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _getFilteredCards(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBotCard extends StatelessWidget {
  final VoidCallback onTap;
  final double speechBubbleTop;
  const ChatBotCard({Key? key, required this.onTap, this.speechBubbleTop = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: speechBubbleTop, // 말풍선의 top 값을 매개변수로 받아서 설정
          child: SpeechBubble(
            text: '새 채팅창을 만드세요. 코비가 원하는것을 알려드려요',
            color: Color(0xfff39801),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatBotPage()));
          },
          child: Container(
            margin:
                const EdgeInsets.only(top: 40), // Added margin to shift down
            width: double.infinity,
            height: 200, // 챗봇 카드 높이 증가
            decoration: BoxDecoration(
              color: Color(0xff30619c),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // 그림자 농도 증가
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 5), // 그림자 위치 조정
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 55.0), // 원하는 값으로 조절
                  child: Icon(Icons.chat_bubble,
                      color: Colors.white, size: 50), // 더 큰 아이콘
                ),
                SizedBox(height: 20),
                Text(
                  '챗봇',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // 텍스트 크기 증가
                    fontWeight: FontWeight.bold, // 텍스트 굵게
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TimetableCard extends StatelessWidget {
  final VoidCallback onTap;
  final double speechBubbleTop;
  const TimetableCard(
      {Key? key, required this.onTap, this.speechBubbleTop = -40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: speechBubbleTop, // 말풍선의 top 값을 매개변수로 받아서 설정
          child: SpeechBubble(
            text: '새 시간표를 생성해보세요',
            color: Color(0xfff39801),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TimetablePage()));
          },
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Color(0xff30619c),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 55.0), // 원하는 값으로 조절
                  child:
                      Icon(Icons.calendar_today, color: Colors.white, size: 40),
                ),
                Spacer(),
                Text(
                  '시간표 제작',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BusInfoCard extends StatelessWidget {
  final VoidCallback onTap;
  final double speechBubbleTop;
  const BusInfoCard({Key? key, required this.onTap, this.speechBubbleTop = -40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: speechBubbleTop, // 말풍선의 top 값을 매개변수로 받아서 설정
          child: SpeechBubble(
            text: '버스 시간표를 확인하세요',
            color: Color(0xfff39801),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BusChoosePage()));
          },
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Color(0xff30619c),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 55.0), // 원하는 값으로 조절
                  child:
                      Icon(Icons.directions_bus, color: Colors.white, size: 40),
                ),
                Spacer(),
                Text(
                  '버스 시간표 확인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SpeechBubble extends StatelessWidget {
  final String text;
  final Color color;

  const SpeechBubble({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SpeechBubblePainter(color: color),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: BlinkingText(
          text: text,
        ),
      ),
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  final Color color;

  SpeechBubblePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(10, 0)
      ..lineTo(size.width - 10, 0)
      ..quadraticBezierTo(size.width, 0, size.width, 10)
      ..lineTo(size.width, size.height - 10)
      ..quadraticBezierTo(size.width, size.height, size.width - 10, size.height)
      ..lineTo(10, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - 10)
      ..lineTo(0, 10)
      ..quadraticBezierTo(0, 0, 10, 0)
      ..close();

    final tailPath = Path()
      ..moveTo(size.width / 2 - 5, size.height)
      ..lineTo(size.width / 2 + 5, size.height)
      ..lineTo(size.width / 2, size.height + 10)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(tailPath, paint);
  }

  @override
  bool shouldRepaint(SpeechBubblePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class BlinkingText extends StatefulWidget {
  final String text;
  const BlinkingText({Key? key, required this.text}) : super(key: key);

  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Text(
        widget.text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
