import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; // 로그인 화면 또는 동의 후 보여줄 화면을 임포트
import 'package:flutter/services.dart'; // SystemNavigator를 사용하기 위해 추가

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KOBI: 코리아텍 비서',
      home: ConsentChecker(),
    );
  }
}

class ConsentChecker extends StatefulWidget {
  @override
  _ConsentCheckerState createState() => _ConsentCheckerState();
}

class _ConsentCheckerState extends State<ConsentChecker> {
  bool _isConsentGiven = false;

  @override
  void initState() {
    super.initState();
    _checkConsent();
  }

  Future<void> _checkConsent() async {
    final prefs = await SharedPreferences.getInstance();
    final isConsentGiven = prefs.getBool('isConsentGiven') ?? false;

    if (!isConsentGiven) {
      _showConsentDialog();
    } else {
      setState(() {
        _isConsentGiven = true;
      });
    }
  }

  void _showConsentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('개인(신용)정보 수집·이용 동의서'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '나만의 학교정보제공 서비스 코비:코리아텍 비서 제작 팀은 학사정보 수집 등과 관련하여 본인의 개인정보를 수집·이용하거나 제3자에게 제공·조회하고자 하는 경우에는「개인정보 보호법」15조, 제17조, 제24조에 따라 본인의 동의를 얻어야 합니다. 이에 본인은 개인정보를 수집·이용 또는 제공·조회하는 것에 동의합니다.',
                ),
                SizedBox(height: 16),
                Text(
                  '1. 수집·이용에 관한 사항',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '-------------------------------------------------------------------------------------------',
                ),
                Text(
                  '| 수집·이용 목적 | 학사정보 수집 - 개인 맞춤 강의 추천 및 e-learning 사이트 로그인 |',
                ),
                Text(
                  '-------------------------------------------------------------------------------------------',
                ),
                Text(
                  '| 수집·이용 항목 | - ￭ 학사정보: 학년, 수강이력, 학점이수내역, 학부/과 ￭ 로그인정보: 학생 아우누리 ID와 PW ',
                ),
                Text(
                  '※ 동 사실에 대하여 별도 통보를 하지 않으며 본 동의 이전에 발생한 개인(신용)정보도 포함됩니다.',
                ),
                Text(
                  '제공받는 자 | ￭ 나만의 학교정보제공 서비스 코비:코리아텍 비서 제작 팀',
                ),
                Text(
                  '-------------------------------------------------------------------------------------------',
                ),
                Text(
                  '| 보유·이용 기간 | 위 개인정보는 수집·이용에 관한 동의일로부터 앱 종료시 까지 위 이용목적을 위하여 보유·이용됩니다. 단, 졸업 이후에도 민원처리, 법령상 의무이행에 따라 보유·이용할 수 있습니다.',
                ),
                Text(
                  '-------------------------------------------------------------------------------------------',
                ),
                Text(
                  '| 수집·이용 거부 | 위 개인정보의 수집․이용에 관한 동의는 거부하실 수 있으며, 다만 동의하지 않으시는 경우 앱 사용에 제한이 있을 수 있습니다.',
                ),
                Text(
                  '-------------------------------------------------------------------------------------------',
                ),
                Text(
                  '| 수집·이용 동의 여부 | 위와 같이 본인의 학사정보를 수집·이용하는 것에 동의합니다.\n위 목적으로 다음과 같은 본인의 로그인정보를 수집·이용하는 것에 동의합니다.',
                ),
                Text(
                  '-------------------------------------------------------------------------------------------',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('동의 안함'),
              onPressed: () {
                SystemNavigator.pop(); // 앱 종료
              },
            ),
            TextButton(
              child: Text('동의함'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isConsentGiven', true);
                Navigator.of(context).pop();
                setState(() {
                  _isConsentGiven = true;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConsentGiven) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Login(),
      ),
    );
  }
}
