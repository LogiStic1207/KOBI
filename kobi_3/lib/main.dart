import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'login.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

main() async {
  // 가로모드 비활성화
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitUp,
  ]);
  _initNotiSetting();

  runApp(MaterialApp(home: MyApp()));
}

void _initNotiSetting() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final initSettings = InitializationSettings(
    android: initSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AgreeDialog();
  }

  void InfoDialog() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // 둥근 모서리
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          // Dialog Main Title
          title: Column(
            children: [
              new Text(
                "앱 및 개발자 정보",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("앱 버전: $version"),
              Text(" "),
              Text("[Contact]"),
              Text("Email: msh050533@gmail.com"),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "확인",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                      color: Colors.purple, // 텍스트 색상을 여기서 설정합니다.
                    ),
                  ),
                  style: TextButton.styleFrom(
                     Colors.purple, // 버튼의 전경색을 설정합니다. (예: 텍스트 색상)
                  ),
                ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CNU Dorm 자가진단',
      theme: ThemeData(primarySwatch: Colors.purple, accentColor: Colors.amber),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('KOBI: 코리아텍 비서'),
          actions: [
            IconButton(
                onPressed: () => InfoDialog(),
                icon: Icon(Icons.info_outline))
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Login(),
        ),
      ),
    );
  }
}