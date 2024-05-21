import 'package:flutter/material.dart';
import 'package:kobi_3/menu/citybuspage.dart';
import 'package:kobi_3/menu/shuttlebuspage.dart';

class BusChoosePage extends StatelessWidget {
  const BusChoosePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('버스정보선택'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 셔틀버스 버튼
              _buildBusButton(
                context,
                '셔틀버스',
                Icons.directions_bus_rounded,
                Colors.orange,
                ShuttlebusPage(),
                width: double.infinity, // 컨테이너 너비 설정
                height: 100, // 컨테이너 높이 설정
              ),
              const SizedBox(height: 30), // 컨테이너 사이에 공백 추가
              // 시내버스 버튼
              _buildBusButton(
                context,
                '시내버스',
                Icons.directions_bus_rounded,
                Colors.orange,
                CitybusPage(),
                width: double.infinity, // 컨테이너 너비 설정
                height: 100, // 컨테이너 높이 설정
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 컨테이너 빌드 함수
  Widget _buildBusButton(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    Widget page, {
    double? width, // 너비를 매개변수로 받음
    double? height, // 높이를 매개변수로 받음
  }) {
    return Container(
      width: 500, // 너비 설정
      height: 250, // 높이 설정
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff30619c),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            Icon(
              icon,
              size: 24,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
