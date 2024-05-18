import 'package:flutter/material.dart';
import 'package:kobi_3/menu/shuttlecitychoose.dart';
import 'package:kobi_3/menu/timetablepage.dart';
import 'menu/inquiry_page.dart';
import 'menu/mypage.dart';
import 'menu/options.dart';
import 'chatbotpage.dart';
import 'style/styles.dart';

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

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

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
                  MaterialPageRoute(builder: (context) => BusChoosePage()),
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
                        // Add your logout functionality here
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
                      Text(
                        'All',
                        style: AppStyle.m12b
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                      const SizedBox(width: 30),
                      Text('Favourite', style: AppStyle.m12bt),
                      const SizedBox(width: 30),
                      Text('Recommended', style: AppStyle.m12bt),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChatBotCard(),
                        const SizedBox(height: 60),
                        TimetableCard(),
                      ],
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
  const ChatBotCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: -40,
          child: SpeechBubble(
            text: '새 채팅창을 만드세요. 코비가 원하는것을 알려드려요',
            color: Color(0xfff39801),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatBotPage()),
            );
          },
          child: Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: Color(0xff30619c),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 105.0), // 원하는 값으로 조절
                  child: Icon(Icons.add, color: Colors.white, size: 40),
                ),
                // Spacer를 제거하고 SizedBox로 조절
                SizedBox(height: 20),
                Spacer(),
                Text(
                  '챗봇',
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

class TimetableCard extends StatelessWidget {
  const TimetableCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: -40,
          child: SpeechBubble(
            text: '새 시간표를 생성해보세요',
            color: Color(0xfff39801),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TimetablePage()),
            );
          },
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Color(0xff30619c),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 55.0), // 원하는 값으로 조절
                  child: Icon(Icons.add, color: Colors.white, size: 40),
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
