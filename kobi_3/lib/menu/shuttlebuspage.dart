import 'package:flutter/material.dart';

class ShuttlebusPage extends StatefulWidget {
  const ShuttlebusPage({super.key});

  @override
  State<ShuttlebusPage> createState() => _ShuttlebusPageState();
}

class _ShuttlebusPageState extends State<ShuttlebusPage> {
  final Map<String, Map<String, List<String>>> busSchedules = {
    '순환(셔틀) 노선': {'천안 셔틀': [], '청주 셔틀': []},
    '주중 노선': {
      '천안역': [],
      '터미널': [],
      '두정역': [],
      '아산/KTX': [],
      '용암동': [],
      '동남지구': [],
      '산남/분평': [],
      '세종': [],
      '서울(교대역)': [],
      '서울 월요일 등교 추가 (교대역)': [],
      '서울 월요일 등교 추가 (동천역)': [],
      '서울 금요일 하교 추가 1': [],
      '서울 금요일 하교 추가 2': [],
      '대전 일요일 등교 1': [],
      '대전 일요일 등교 2': [],
      '대전 금요일 하교 1': [],
      '대전 금요일 하교 2': [],
    },
    '주말 노선': {
      '천안셔틀 (토/일)': [],
      '일학습병행대학(토/시내)': [],
      '일학습병행대학(토/천안아산역)': [],
      '전문대학원 (토)': [],
      '대학원 (토)': [],
    },
  };

  String? selectedBus;
  String? selectedDirection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('셔틀버스 시간표'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                _buildDropdownButton(
                  hint: '노선을 선택하세요',
                  value: selectedBus,
                  items: busSchedules.keys.toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBus = value;
                      selectedDirection = null;
                    });
                  },
                ),
                if (selectedBus != null)
                  _buildDropdownButton(
                    hint: '지역을 선택하세요',
                    value: selectedDirection,
                    items: busSchedules[selectedBus]!.keys.toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDirection = value;
                      });
                    },
                  ),
              ],
            ),
            if (selectedDirection != null)
              Expanded(child: _buildScheduleTable(selectedDirection!))
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownButton({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Flexible(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(hint),
          value: value,
          onChanged: onChanged,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildScheduleTable(String direction) {
    final tableBuilders = {
      '천안 셔틀': _buildCustomTable1,
      '청주 셔틀': _buildCustomTable2,
      '천안역': _buildCustomTable3,
      '터미널': _buildCustomTable4,
      '두정역': _buildCustomTable5,
      '아산/KTX': _buildCustomTable6,
      '용암동': _buildCustomTable7,
      '동남지구': _buildCustomTable8,
      '산남/분평': _buildCustomTable9,
      '세종': _buildCustomTable10,
      '서울(교대역)': _buildCustomTable11,
      '서울 월요일 등교 추가 (교대역)': _buildCustomTable12,
      '서울 월요일 등교 추가 (동천역)': _buildCustomTable13,
      '서울 금요일 하교 추가 1': _buildCustomTable14,
      '서울 금요일 하교 추가 2': _buildCustomTable15,
      '대전 일요일 등교 1': _buildCustomTable16,
      '대전 일요일 등교 2': _buildCustomTable17,
      '대전 금요일 하교 1': _buildCustomTable18,
      '대전 금요일 하교 2': _buildCustomTable19,
      '천안셔틀 (토/일)': _buildCustomTable20,
      '일학습병행대학(토/시내)': _buildCustomTable21,
      '일학습병행대학(토/천안아산역)': _buildCustomTable22,
      '전문대학원 (토)': _buildCustomTable23,
      '대학원 (토)': _buildCustomTable24,
    };
    return tableBuilders[direction]!();
  }

  Widget _buildDefaultTable() {
    return const Text('test');
  }

  Widget _buildCustomTable1() {
    return _buildDataTable(
      columns: ['승하차장명', '1회', '2회', '3회', '4회', '5회', '6회', '목·금 추가'],
      rows: [
        [
          '본교',
          '11:10',
          '13:10',
          '14:10',
          '16:10',
          '20:00',
          '21:00',
          '14:10/16:30'
        ],
        ['2캠퍼스', '', '', '14:35', '', '', '', ''],
        [
          '천안터미널',
          '11:35',
          '13:35',
          '14:42',
          '16:35',
          '20:25',
          '21:25',
          '14:35/16:55'
        ],
        [
          '천안역',
          '11:40',
          '13:40',
          '14:47',
          '16:40',
          '20:30',
          '21:30',
          '14:40/17:00'
        ],
        [
          '본교',
          '12:10',
          '14:10',
          '15:15',
          '17:10',
          '21:00',
          '22:00',
          '15:10/17:30'
        ],
      ],
    );
  }

  Widget _buildCustomTable2() {
    return _buildDataTable(
      columns: [
        '승하차장명\n(방향)',
        '1회\n(본교)',
        '2회\n(청주역->본교)',
        '3회\n(오창과학단지)',
        '4회\n(청주역->본교)',
        '목·금 추가\n(오창과학단지)'
      ],
      rows: [
        ['본교', '역방향 순서 ↑', '13:30', '15:40', '20:00', '22:10'],
        ['옥산(가락 3리)', '12:12', '13:57', '', '20:25', ''],
        ['청주역\n(서촌동BS/청주역BS)', '12:10', '14:07', '', '20:32', ''],
        ['지웰시티', '', '14:12', '', '20:39', ''],
        ['솔밭공원', '12:05', '14:17', '', '20:41', ''],
        ['HS포래\n(봉명우체국 BS)', '12:02', '14:21', '', '20:45', ''],
        ['오창과학단지', '', '', '하차', '', '하차'],
        ['성모병원', '', '', '하차', '', '하차'],
        ['신봉사거리\n(LPG 충전소)', '', '', '하차', '', '하차'],
        ['봉명사거리', '', '', '하차', '', '하차'],
        ['사창사거리\n(고용센터/하이마트)', '12:00', '14:25', '하차', '20:48', '하차'],
        ['체육관\n(네파/맞은편)', '11:58', '14:30', '하차', '20:50', '하차'],
        ['상당공원 C\n(지하상가 BS)', '', '14:33', '하차', '20:53', '하차'],
        ['상당공원 B\n(안경매니져 성안점)', '11:56', '', '', '', ''],
        ['석교동 육거리', '11:54', '14:36', '하차', '20:56', '하차'],
        ['삼영가스', '', '14:39', '하차', '21:00', '하차'],
        ['용암동 현대', '11:51', '14:45', '하차', '21:02', '하차'],
        ['방서동\n(다이소)', '11:50', '', '종점', '', '종점'],
        ['상당공원 A\n(상공회의소)', '', '15:00', '', '21:15', ''],
        ['문화산업단지', '', '15:05', '', '21:20', ''],
        ['성모병원\n(율량 맥도날드)', '', '15:12', '', '21:25', ''],
        ['과학단지\n(오창프라자)', '', '15:23', '', '21:35', ''],
        ['본교', '12:50', '15:50', '', '21:50', ''],
      ],
    );
  }

  Widget _buildDataTable(
      {required List<String> columns, required List<List<String>> rows}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: columns
                .map((col) => DataColumn(
                      label: Center(
                        child: Text(
                          col,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
                .toList(),
            rows: rows
                .map((row) => DataRow(
                      cells: row
                          .map((cell) => DataCell(
                                Center(child: Text(cell)),
                              ))
                          .toList(),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  // Repeat the same pattern for other _buildCustomTableN methods

  Widget _buildCustomTable3() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['08:10', '천안역 (학화호두과자 앞)'],
        ['08:18', '한양 수자인BS'],
        ['08:21', '청당동 (벽산블루밍)'],
        ['08:26', '부영@'],
        ['승하차', '동우@'],
        ['승하차', '신계초'],
        ['승하차', '운전리'],
        ['승하차', '연춘리'],
        ['승하차', '중앙@'],
        ['08:50', '대학(본교)'],
      ],
    );
  }

  Widget _buildCustomTable4() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['07:40', '동일하이빌@'],
        ['07:43', '주공11단지@'],
        ['08:05', '천안 터미널(신세계앞 횡단보도)'],
        ['08:11', '제일고 맞은편(구 교육청)'],
        ['08:13', '원성동(GS슈퍼)'],
        ['08:14', '삼룡교(유니클로, 구 한방병원)'],
        ['08:15', '바로약국 앞'],
        ['승하차', '중앙@'],
        ['08:50', '대학(본교)'],
      ],
    );
  }

  Widget _buildCustomTable5() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['07:41', '두정역'],
        ['07:45', '노동부 (천안지방사무소)'],
        ['07:46', '늘푸른@'],
        ['07:48', '성정지하도(6단지)'],
        ['07:49', '전자랜드'],
        ['07:50', '광혜당약국'],
        ['07:53', '충무병원'],
        ['07:55', '세종아트빌라BS(구 일봉회관)'],
        ['07:56', '남부오거리(귀뚜라미 보일러)'],
        ['07:58', '삼룡교(유니클로, 구 한방병원)'],
        ['08:00', '바로약국 앞'],
        ['승하차', '동우@'],
        ['승하차', '신계초'],
        ['승하차', '운전리'],
        ['승하차', '연춘리'],
        ['승하차', '중앙@'],
        ['08:50', '대학(본교)'],
      ],
    );
  }

  Widget _buildCustomTable6() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['07:20', '온양온천역1번출구BS'],
        ['07:25', '이마트 아산점'],
        ['07:35', '배방읍행정복지센터BS'],
        ['07:45', '호서웨딩홀BS'],
        ['07:52', '천안아산KTX(3번출구 6번 승강장)'],
        ['07:55', 'Y-CITY(상공회의소건너편횡단보도)'],
        ['07:57', '한화 꿈에그린@ BS'],
        ['08:01', '용암마을(하나은행건너편 용암지하도입구)'],
        ['08:05', '신방동 리차드'],
        ['08:08', '신방동 GS주유소'],
        ['08:18', '청당동(벽산블루밍)'],
        ['08:50', '대학(본교)'],
      ],
    );
  }

  Widget _buildCustomTable7() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['07:28', '방서동(다이소)'],
        ['07:30', '용암동현대@'],
        ['07:31', 'GS대청주유소 맞은편(용암동)'],
        ['07:33', '석교동 육거리'],
        ['07:36', '상당공원A(상공회의소)'],
        ['07:40', '문화 산업단지(구 제조창)'],
        ['07:45', '성모병원(율량 맥도널드)'],
        ['08:00', '과학단지(오창프라자)'],
        ['08:50', '대학(본교)'],
      ],
    );
  }

  Widget _buildCustomTable8() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['07:20', '동남지구(대원칸타빌 BS)'],
        ['07:22', '프라우 삼성산부인과'],
        ['07:24', '청주혜원학교'],
        ['07:25', '금천광장(농협앞)'],
        ['07:28', '용담동베이징(초양교회 앞)'],
        ['07:37', '상당공원B(안경매니저 성안점 앞)'],
        ['07:40', '체육관(NEPA)'],
        ['07:42', '사창사거리(청주고용센터맞은편BS)'],
        ['07:46', '갤러리호텔(봉명우체국BS)'],
        ['07:50', '솔밭공원'],
        ['08:50', '대학(본교)'],
      ],
    );
  }

  Widget _buildCustomTable9() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['07:15', '분평동 전자랜드'],
        ['07:17', '남성초등학교'],
        ['07:20', '산남동수곡교회'],
        ['07:22', '충북 원예농협(GS마트)'],
        ['07:26', '충북대병원BS'],
        ['07:27', 'KBS맞은편'],
        ['07:31', '개신동 푸르지오@ BS'],
        ['07:32', '삼일아파트BS'],
        ['07:37', '시외버스TM건너(롯데마트 앞)'],
        ['07:42', '흥덕고교 BS'],
        ['07:46', '청주역A(서촌동 BS)'],
        ['07:49', '옥산(가락3리 BS)'],
        ['08:50', '대학(본교)'],
      ],
    );
  }

  Widget _buildCustomTable10() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['07:20', '9단지중흥S클래스(달콤제작소 앞)'],
        ['07:25', '세종시청(자율주행서비스정류장)'],
        ['07:28', '세종 순복음더사랑교회'],
        ['07:34', '소방청'],
        ['07:36', 'LG전자 세종본점'],
        ['07:41', '정부세종청사정류장(남측)BS'],
        ['07:43', '도담풍경채도서관(도담마을6,9단지 BS)'],
        ['07:52', '범지기마을10단지 BS'],
        ['07:37', '시외버스TM건너(롯데마트 앞)'],
        ['08:05', '조치원 자이아파트BS(노브랜드)'],
        ['08:10', '신봉초등학교BS'],
        ['08:50', '대학(본교)'],
      ],
    );
  }

  Widget _buildCustomTable11() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['07:20', '교대'],
        ['07:37', '동천역 환승정류장(하교 시 미하차)'],
        ['07:40', '죽전간이정류장'],
        ['08:50', '대학(본교)'],
      ],
    );
  }

  Widget _buildCustomTable12() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['07:10', '3호선 교대역(14번 출구)'],
        ['08:40', '대학(본교)'],
      ],
    );
  }

  Widget _buildCustomTable13() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['07:30', '동천역 환승정류장'],
        ['07:33', '죽전 간이정류장'],
        ['08:40', '대학(본교)'],
      ],
    );
  }

  Widget _buildCustomTable14() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['14:10', '대학'],
        ['하차', '죽전 간이정류장'],
        ['도착', '3호선 교대역(14번 출구)'],
      ],
    );
  }

  Widget _buildCustomTable15() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['16:10', '대학'],
        ['하차', '죽전 간이정류장'],
        ['도착', '3호선 교대역(14번 출구)'],
      ],
    );
  }

  Widget _buildCustomTable16() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['18:10', '대전역'],
        ['18:15', '터미널'],
        ['도착', '대학'],
      ],
    );
  }

  Widget _buildCustomTable17() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['18:20', '대전역'],
        ['18:25', '터미널'],
        ['도착', '대학'],
      ],
    );
  }

  Widget _buildCustomTable18() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['14:00', '대학'],
        ['하차', '터미널'],
        ['하차', '대전역'],
      ],
    );
  }

  Widget _buildCustomTable19() {
    return _buildDataTable(
      columns: ['시간', '장소'],
      rows: [
        ['18:20', '대학'],
        ['하차', '터미널'],
        ['하차', '대전역'],
      ],
    );
  }

  Widget _buildCustomTable20() {
    return _buildDataTable(
      columns: ['승하차장명', '1회 토요일', '2회 토요일', '3회 일요일', '4회 일요일', '5회 일요일'],
      rows: [
        ['본교', '14:00', '', '17:00', '', ''],
        ['천안터미널', '14:25', '18:30', '17:25', '21:15', '21:30'],
        ['천안역', '14:30', '18:35', '17:30', '21:20', '21:35'],
        ['본교', '15:00', '19:15', '18:10', '21:50', '22:00'],
      ],
    );
  }

  Widget _buildCustomTable21() {
    return _buildDataTable(
      columns: ['승하차장명', '1회 등교', '2회 등교', '3회 등교', '4회 하교', '5회 하교'],
      rows: [
        ['두정캠퍼스', '', '08:05', '', '', ''],
        ['두정역', '08:00', '08:10', '10:10', '', ''],
        ['천안터미널(신세계 앞 횡단보도)', '08:05', '08:15', '10:15', '', ''],
        ['천안역 A(학화 호두과자 앞)', '08:10', '08:20', '10:20', '', ''],
        ['본교', '도착', '도착', '도착', '19:10', '19:20'],
        ['천안역 B(태극당 건너 BS)', '', '', '', '19:40', '19:50'],
        ['천안터미널', '', '', '', '19:50', '20:00'],
        ['두정역', '', '', '', '종점', '종점'],
      ],
    );
  }

  Widget _buildCustomTable22() {
    return _buildDataTable(
      columns: ['승하차장명', '1회 등교', '1회 하교'],
      rows: [
        ['대학(본교)', '', '19:20'],
        ['천안아산역(3번출구 6번승강장)', '08:15', '도착'],
        ['대학(본교)', '도착', ''],
      ],
    );
  }

  Widget _buildCustomTable23() {
    return _buildDataTable(
      columns: ['승하차장명', '1회 등교', '2회 등교', '4회 하교', '5회 하교'],
      rows: [
        ['천안아산 KTX(3번출구)', '08:30', '12:45', '', ''],
        ['천안역 B(태극당 건너 BS)', '08:45', '13:00', '', ''],
        ['천안터미널(신세계 앞 횡단보도)', '08:55', '13:10', '', ''],
        ['두정역', '09:00', '13:15', '', ''],
        ['두정캠퍼스', '도착', '도착', '16:40', '19:35'],
        ['두정역', '', '', '하차', '하차'],
        ['천안터미널(신세계 앞 횡단보도)', '', '', '하차', '하차'],
        ['천안역 A(학화 호두과자 앞)', '', '', '하차', '하차'],
        ['천안아산 KTX(3번출구)', '', '', '종점', '종점'],
      ],
    );
  }

  Widget _buildCustomTable24() {
    return _buildDataTable(
      columns: ['승하차장명', '1회 등교', '2회 하교', '3회 하교'],
      rows: [
        ['두정역', '07:50', '', ''],
        ['천안터미널(신세계 앞 횡단보도)', '08:00', '', ''],
        ['천안역 A(학화 호두과자 앞)', '08:05', '', ''],
        ['본교', '도착', '16:20', '18:10'],
        ['천안역(태극당 건너 BS)', '', '하차', '하차'],
        ['천안역 A(학화 호두과자 앞)', '', '하차', '하차'],
        ['천안터미널(신세계 앞 횡단보도)', '', '종점', '종점'],
      ],
    );
  }
}
