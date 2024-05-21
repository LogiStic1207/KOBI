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
      '대전 금요일 하교 2': []
    },
    '주말 노선': {
      '천안셔틀 (토/일)': [],
      '일학습병행대학(토/시내)': [],
      '일학습병행대학(토/천안아산역)': [],
      '전문대학원 (토)': [],
      '대학원 (토)': []
    },
  };

  String? selectedBus;
  String? selectedDirection;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('셔틀버스 시간표'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: SizedBox(
                    width: deviceWidth / 2,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('노선을 선택하세요'),
                      value: selectedBus,
                      onChanged: (value) {
                        setState(() {
                          selectedBus = value;
                          selectedDirection = null;
                        });
                      },
                      items: busSchedules.keys.map((String bus) {
                        return DropdownMenuItem<String>(
                          value: bus,
                          child: Text(bus),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (selectedBus != null) ...[
                  Flexible(
                    child: SizedBox(
                      width: deviceWidth / 2,
                      child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text('지역을 선택하세요'),
                          value: selectedDirection,
                          onChanged: (value) {
                            setState(() {
                              selectedDirection = value;
                            });
                          },
                          items: busSchedules[selectedBus]!
                              .keys
                              .map((String direction) {
                            return DropdownMenuItem<String>(
                              value: direction,
                              child: Text(direction),
                            );
                          }).toList()),
                    ),
                  ),
                ],
              ],
            ),
            if (selectedDirection != null)
              Expanded(child: _buildScheduleTable(selectedDirection!))
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTable(String direction) {
    switch (direction) {
      case '천안 셔틀':
        return _buildCustomTable1();
      case '청주 셔틀':
        return _buildCustomTable2();
      case '천안역':
        return _buildCustomTable3();
      case '터미널':
        return _buildCustomTable4();
      case '두정역':
        return _buildCustomTable5();
      case '아산/KTX':
        return _buildCustomTable6();
      case '용암동':
        return _buildCustomTable7();
      case '동남지구':
        return _buildCustomTable8();
      case '산남/분평':
        return _buildCustomTable9();
      case '세종':
        return _buildCustomTable10();
      case '서울(교대역)':
        return _buildCustomTable11();
      case '서울 월요일 등교 추가 (교대역)':
        return _buildCustomTable12();
      case '서울 월요일 등교 추가 (동천역)':
        return _buildCustomTable13();
      case '서울 금요일 하교 추가 1':
        return _buildCustomTable14();
      case '서울 금요일 하교 추가 2':
        return _buildCustomTable15();
      case '대전 일요일 등교 1':
        return _buildCustomTable16();
      case '대전 일요일 등교 2':
        return _buildCustomTable17();
      case '대전 금요일 하교 1':
        return _buildCustomTable18();
      case '대전 금요일 하교 2':
        return _buildCustomTable19();
      case '천안셔틀 (토/일)':
        return _buildCustomTable20();
      case '일학습병행대학(토/시내)':
        return _buildCustomTable21();
      case '일학습병행대학(토/천안아산역)':
        return _buildCustomTable22();
      case '전문대학원 (토)':
        return _buildCustomTable23();
      case '대학원 (토)':
        return _buildCustomTable24();
      default:
        return _buildDefaultTable();
    }
  }

  Widget _buildDefaultTable() {
    return Text('test');
  }

  Widget _buildCustomTable1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: [
              DataColumn(
                label: Center(
                  child: Text(
                    '승하차장명',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '1회',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '2회',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '3회',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '4회',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '5회',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '6회',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '목·금 추가',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Center(child: Text('본교'))),
                DataCell(Center(child: Text('11:10'))),
                DataCell(Center(child: Text('13:10'))),
                DataCell(Center(child: Text('14:10'))),
                DataCell(Center(child: Text('16:10'))),
                DataCell(Center(child: Text('20:00'))),
                DataCell(Center(child: Text('21:00'))),
                DataCell(Center(child: Text('14:10/16:30'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('2캠퍼스'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('14:35'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안터미널'))),
                DataCell(Center(child: Text('11:35'))),
                DataCell(Center(child: Text('13:35'))),
                DataCell(Center(child: Text('14:42'))),
                DataCell(Center(child: Text('16:35'))),
                DataCell(Center(child: Text('20:25'))),
                DataCell(Center(child: Text('21:25'))),
                DataCell(Center(child: Text('14:35/16:55'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안역'))),
                DataCell(Center(child: Text('11:40'))),
                DataCell(Center(child: Text('13:40'))),
                DataCell(Center(child: Text('14:47'))),
                DataCell(Center(child: Text('16:40'))),
                DataCell(Center(child: Text('20:30'))),
                DataCell(Center(child: Text('21:30'))),
                DataCell(Center(child: Text('14:40/17:00'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('본교'))),
                DataCell(Center(child: Text('12:10'))),
                DataCell(Center(child: Text('14:10'))),
                DataCell(Center(child: Text('15:15'))),
                DataCell(Center(child: Text('17:10'))),
                DataCell(Center(child: Text('21:00'))),
                DataCell(Center(child: Text('22:00'))),
                DataCell(Center(child: Text('15:10/17:30'))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTable2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columnSpacing: 20.0,
            columns: [
              DataColumn(
                label: Center(
                  child: Text(
                    '승하차장명\n(방향)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '1회\n(본교)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '2회\n(청주역->본교)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '3회\n(오창과학단지)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '4회\n(청주역->본교)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '목·금 추가\n(오창과학단지)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Center(child: Text('본교'))),
                DataCell(Center(child: Text('역방향 순서 ↑'))),
                DataCell(Center(child: Text('13:30'))),
                DataCell(Center(child: Text('15:40'))),
                DataCell(Center(child: Text('20:00'))),
                DataCell(Center(child: Text('22:10'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('옥산(가락 3리)'))),
                DataCell(Center(child: Text('12:12'))),
                DataCell(Center(child: Text('13:57'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('20:25'))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('청주역\n(서촌동BS/청주역BS)'))),
                DataCell(Center(child: Text('12:10'))),
                DataCell(Center(child: Text('14:07'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('20:32'))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('지웰시티'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('14:12'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('20:39'))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('솔밭공원'))),
                DataCell(Center(child: Text('12:05'))),
                DataCell(Center(child: Text('14:17'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('20:41'))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('HS포래\n(봉명우체국 BS)'))),
                DataCell(Center(child: Text('12:02'))),
                DataCell(Center(child: Text('14:21'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('20:45'))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('오창과학단지'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('성모병원'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('신봉사거리\n(LPG 충전소)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('봉명사거리'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('사창사거리\n(고용센터/하이마트)'))),
                DataCell(Center(child: Text('12:00'))),
                DataCell(Center(child: Text('14:25'))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text('20:48'))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('체육관\n(네파/맞은편)'))),
                DataCell(Center(child: Text('11:58'))),
                DataCell(Center(child: Text('14:30'))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text('20:50'))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('상당공원 C\n(지하상가 BS)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('14:33'))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text('20:53'))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('상당공원 B\n(안경매니져 성안점)'))),
                DataCell(Center(child: Text('11:56'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('석교동 육거리'))),
                DataCell(Center(child: Text('11:54'))),
                DataCell(Center(child: Text('14:36'))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text('20:56'))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('삼영가스'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('14:39'))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text('21:00'))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('용암동 현대'))),
                DataCell(Center(child: Text('11:51'))),
                DataCell(Center(child: Text('14:45'))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text('21:02'))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('방서동\n(다이소)'))),
                DataCell(Center(child: Text('11:50'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('종점'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('종점'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('상당공원 A\n(상공회의소)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('15:00'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('21:15'))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('문화산업단지'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('15:05'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('21:20'))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('성모병원\n(율량 맥도날드)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('15:12'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('21:25'))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('과학단지\n(오창프라자)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('15:23'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('21:35'))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('본교'))),
                DataCell(Center(child: Text('12:50'))),
                DataCell(Center(child: Text('15:50'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('21:50'))),
                DataCell(Center(child: Text(''))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTable3() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('08:10'),)),
              DataCell(Center(child: Text('천안역 (학화호두과자 앞)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:18'),)),
              DataCell(Center(child: Text('한양 수자인BS'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:21'),)),
              DataCell(Center(child: Text('청당동 (벽산블루밍)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:26'),)),
              DataCell(Center(child: Text('부영@'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('승하차'),)),
              DataCell(Center(child: Text('동우@'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('승하차'),)),
              DataCell(Center(child: Text('신계초'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('승하차'),)),
              DataCell(Center(child: Text('운전리'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('승하차'),)),
              DataCell(Center(child: Text('연춘리'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('승하차'),)),
              DataCell(Center(child: Text('중앙@'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:50'),)),
              DataCell(Center(child: Text('대학(본교)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable4() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('07:40'),)),
              DataCell(Center(child: Text('동일하이빌@'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:43'),)),
              DataCell(Center(child: Text('주공11단지@'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:05'),)),
              DataCell(Center(child: Text('천안 터미널(신세계앞 횡단보도)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:11'),)),
              DataCell(Center(child: Text('제일고 맞은편(구 교육청)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:13'),)),
              DataCell(Center(child: Text('원성동(GS슈퍼)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:14'),)),
              DataCell(Center(child: Text('삼룡교(유니클로, 구 한방병원)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:15'),)),
              DataCell(Center(child: Text('바로약국 앞'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('승하차'),)),
              DataCell(Center(child: Text('중앙@'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:50'),)),
              DataCell(Center(child: Text('대학(본교)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable5() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('07:41'),)),
              DataCell(Center(child: Text('두정역'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:45'),)),
              DataCell(Center(child: Text('노동부 (천안지방사무소)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:46'),)),
              DataCell(Center(child: Text('늘푸른@'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:48'),)),
              DataCell(Center(child: Text('성정지하도(6단지)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:49'),)),
              DataCell(Center(child: Text('전자랜드'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:50'),)),
              DataCell(Center(child: Text('광혜당약국'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:53'),)),
              DataCell(Center(child: Text('충무병원'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:55'),)),
              DataCell(Center(child: Text('세종아트빌라BS(구 일봉회관)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:56'),)),
              DataCell(Center(child: Text('남부오거리(귀뚜라미 보일러)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:58'),)),
              DataCell(Center(child: Text('삼룡교(유니클로, 구 한방병원)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:00'),)),
              DataCell(Center(child: Text('바로약국 앞'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('승하차'),)),
              DataCell(Center(child: Text('동우@'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('승하차'),)),
              DataCell(Center(child: Text('신계초'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('승하차'),)),
              DataCell(Center(child: Text('운전리'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('승하차'),)),
              DataCell(Center(child: Text('연춘리'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('승하차'),)),
              DataCell(Center(child: Text('중앙@'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:50'),)),
              DataCell(Center(child: Text('대학(본교)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable6() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('07:20'),)),
              DataCell(Center(child: Text('온양온천역1번출구BS'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:25'),)),
              DataCell(Center(child: Text('이마트 아산점'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:35'),)),
              DataCell(Center(child: Text('배방읍행정복지센터BS'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:45'),)),
              DataCell(Center(child: Text('호서웨딩홀BS'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:52'),)),
              DataCell(Center(child: Text('천안아산KTX(3번출구 6번 승강장)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:55'),)),
              DataCell(Center(child: Text('Y-CITY(상공회의소건너편횡단보도)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:57'),)),
              DataCell(Center(child: Text('한화 꿈에그린@ BS'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:01'),)),
              DataCell(Center(child: Text('용암마을(하나은행건너편 용암지하도입구)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:05'),)),
              DataCell(Center(child: Text('신방동 리차드'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:08'),)),
              DataCell(Center(child: Text('신방동 GS주유소'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:18'),)),
              DataCell(Center(child: Text('청당동(벽산블루밍)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:50'),)),
              DataCell(Center(child: Text('대학(본교)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable7() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('07:28'),)),
              DataCell(Center(child: Text('방서동(다이소)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:30'),)),
              DataCell(Center(child: Text('용암동현대@'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:31'),)),
              DataCell(Center(child: Text('GS대청주유소 맞은편(용암동)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:33'),)),
              DataCell(Center(child: Text('석교동 육거리'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:36'),)),
              DataCell(Center(child: Text('상당공원A(상공회의소)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:40'),)),
              DataCell(Center(child: Text('문화 산업단지(구 제조창)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:45'),)),
              DataCell(Center(child: Text('성모병원(율량 맥도널드)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:00'),)),
              DataCell(Center(child: Text('과학단지(오창프라자)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:50'),)),
              DataCell(Center(child: Text('대학(본교)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable8() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('07:20'),)),
              DataCell(Center(child: Text('동남지구(대원칸타빌 BS)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:22'),)),
              DataCell(Center(child: Text('프라우 삼성산부인과'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:24'),)),
              DataCell(Center(child: Text('청주혜원학교'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:25'),)),
              DataCell(Center(child: Text('금천광장(농협앞)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:28'),)),
              DataCell(Center(child: Text('용담동베이징(초양교회 앞)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:37'),)),
              DataCell(Center(child: Text('상당공원B(안경매니저 성안점 앞)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:40'),)),
              DataCell(Center(child: Text('체육관(NEPA)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:42'),)),
              DataCell(Center(child: Text('사창사거리(청주고용센터맞은편BS)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:46'),)),
              DataCell(Center(child: Text('갤러리호텔(봉명우체국BS)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:50'),)),
              DataCell(Center(child: Text('솔밭공원'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:50'),)),
              DataCell(Center(child: Text('대학(본교)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable9() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('07:15'),)),
              DataCell(Center(child: Text('분평동 전자랜드'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:17'),)),
              DataCell(Center(child: Text('남성초등학교'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:20'),)),
              DataCell(Center(child: Text('산남동수곡교회'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:22'),)),
              DataCell(Center(child: Text('충북 원예농협(GS마트)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:26'),)),
              DataCell(Center(child: Text('충북대병원BS'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:27'),)),
              DataCell(Center(child: Text('KBS맞은편'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:31'),)),
              DataCell(Center(child: Text('개신동 푸르지오@ BS'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:32'),)),
              DataCell(Center(child: Text('삼일아파트BS'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:37'),)),
              DataCell(Center(child: Text('시외버스TM건너(롯데마트 앞)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:42'),)),
              DataCell(Center(child: Text('흥덕고교 BS'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:46'),)),
              DataCell(Center(child: Text('청주역A(서촌동 BS)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:49'),)),
              DataCell(Center(child: Text('옥산(가락3리 BS)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:50'),)),
              DataCell(Center(child: Text('대학(본교)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable10() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('07:20'),)),
              DataCell(Center(child: Text('9단지중흥S클래스(달콤제작소 앞)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:25'),)),
              DataCell(Center(child: Text('세종시청(자율주행서비스정류장)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:28'),)),
              DataCell(Center(child: Text('세종 순복음더사랑교회'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:34'),)),
              DataCell(Center(child: Text('소방청'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:36'),)),
              DataCell(Center(child: Text('LG전자 세종본점'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:41'),)),
              DataCell(Center(child: Text('정부세종청사정류장(남측)BS'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:43'),)),
              DataCell(Center(child: Text('도담풍경채도서관(도담마을6,9단지 BS)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:52'),)),
              DataCell(Center(child: Text('범지기마을10단지 BS'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:37'),)),
              DataCell(Center(child: Text('시외버스TM건너(롯데마트 앞)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:05'),)),
              DataCell(Center(child: Text('조치원 자이아파트BS(노브랜드)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:10'),)),
              DataCell(Center(child: Text('신봉초등학교BS'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:50'),)),
              DataCell(Center(child: Text('대학(본교)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable11() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('07:20'),)),
              DataCell(Center(child: Text('교대'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:37'),)),
              DataCell(Center(child: Text('동천역 환승정류장(하교 시 미하차)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:40'),)),
              DataCell(Center(child: Text('죽전간이정류장'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:50'),)),
              DataCell(Center(child: Text('대학(본교)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable12() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('07:10'),)),
              DataCell(Center(child: Text('3호선 교대역(14번 출구)'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:40'),)),
              DataCell(Center(child: Text('대학(본교)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable13() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('07:30'),)),
              DataCell(Center(child: Text('동천역 환승정류장'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('07:33'),)),
              DataCell(Center(child: Text('죽전 간이정류장'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('08:40'),)),
              DataCell(Center(child: Text('대학(본교)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable14() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('14:10'),)),
              DataCell(Center(child: Text('대학'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('하차'),)),
              DataCell(Center(child: Text('죽전 간이정류장'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('도착'),)),
              DataCell(Center(child: Text('3호선 교대역(14번 출구)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable15() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('16:10'),)),
              DataCell(Center(child: Text('대학'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('하차'),)),
              DataCell(Center(child: Text('죽전 간이정류장'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('도착'),)),
              DataCell(Center(child: Text('3호선 교대역(14번 출구)'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable16() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('18:10'),)),
              DataCell(Center(child: Text('대전역'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('18:15'),)),
              DataCell(Center(child: Text('터미널'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('도착'),)),
              DataCell(Center(child: Text('대학'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable17() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('18:20'),)),
              DataCell(Center(child: Text('대전역'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('18:25'),)),
              DataCell(Center(child: Text('터미널'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('도착'),)),
              DataCell(Center(child: Text('대학'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable18() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('14:00'),)),
              DataCell(Center(child: Text('대학'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('하차'),)),
              DataCell(Center(child: Text('터미널'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('하차'),)),
              DataCell(Center(child: Text('대전역'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable19() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: [
            DataColumn(label: Center(
              child: Text('시간', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
            DataColumn(label: Center(
              child: Text('장소', style: TextStyle(fontWeight: FontWeight.bold),),
            )),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Center(child: Text('18:20'),)),
              DataCell(Center(child: Text('대학'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('하차'),)),
              DataCell(Center(child: Text('터미널'),)),
            ]),
            DataRow(cells: [
              DataCell(Center(child: Text('하차'),)),
              DataCell(Center(child: Text('대전역'),)),
            ]),
          ],
        ),
      )
    );
  }

  Widget _buildCustomTable20() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: [
              DataColumn(
                label: Center(
                  child: Text(
                    '승하차장명',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '1회 토요일',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '2회 토요일',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '3회 일요일',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '4회 일요일',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '5회 일요일',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Center(child: Text('본교'))),
                DataCell(Center(child: Text('14:00'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('17:00'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안터미널'))),
                DataCell(Center(child: Text('14:25'))),
                DataCell(Center(child: Text('18:30'))),
                DataCell(Center(child: Text('17:25'))),
                DataCell(Center(child: Text('21:15'))),
                DataCell(Center(child: Text('21:30'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안역'))),
                DataCell(Center(child: Text('14:30'))),
                DataCell(Center(child: Text('18:35'))),
                DataCell(Center(child: Text('17:30'))),
                DataCell(Center(child: Text('21:20'))),
                DataCell(Center(child: Text('21:35'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('본교'))),
                DataCell(Center(child: Text('15:00'))),
                DataCell(Center(child: Text('19:15'))),
                DataCell(Center(child: Text('18:10'))),
                DataCell(Center(child: Text('21:50'))),
                DataCell(Center(child: Text('22:00'))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTable21() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: [
              DataColumn(
                label: Center(
                  child: Text(
                    '승하차장명',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '1회 등교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '2회 등교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '3회 등교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '4회 하교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '5회 하교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Center(child: Text('두정캠퍼스'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('08:05'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('두정역'))),
                DataCell(Center(child: Text('08:00'))),
                DataCell(Center(child: Text('08:10'))),
                DataCell(Center(child: Text('10:10'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안터미널(신세계 앞 횡단보도)'))),
                DataCell(Center(child: Text('08:05'))),
                DataCell(Center(child: Text('08:15'))),
                DataCell(Center(child: Text('10:15'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안역 A(학화 호두과자 앞)'))),
                DataCell(Center(child: Text('08:10'))),
                DataCell(Center(child: Text('08:20'))),
                DataCell(Center(child: Text('10:20'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('본교'))),
                DataCell(Center(child: Text('도착'))),
                DataCell(Center(child: Text('도착'))),
                DataCell(Center(child: Text('도착'))),
                DataCell(Center(child: Text('19:10'))),
                DataCell(Center(child: Text('19:20'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안역 B(태극당 건너 BS)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('19:40'))),
                DataCell(Center(child: Text('19:50'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안터미널'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('19:50'))),
                DataCell(Center(child: Text('20:00'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('두정역'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('종점'))),
                DataCell(Center(child: Text('종점'))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTable22() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: [
              DataColumn(
                label: Center(
                  child: Text(
                    '승하차장명',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '1회 등교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '1회 하교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Center(child: Text('대학(본교)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('19:20'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안아산역(3번출구 6번승강장)'))),
                DataCell(Center(child: Text('08:15'))),
                DataCell(Center(child: Text('도착'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('대학(본교)'))),
                DataCell(Center(child: Text('도착'))),
                DataCell(Center(child: Text(''))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTable23() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: [
              DataColumn(
                label: Center(
                  child: Text(
                    '승하차장명',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '1회 등교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '2회 등교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '4회 하교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '5회 하교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Center(child: Text('천안아산 KTX(3번출구)'))),
                DataCell(Center(child: Text('08:30'))),
                DataCell(Center(child: Text('12:45'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안역 B(태극당 건너 BS)'))),
                DataCell(Center(child: Text('08:45'))),
                DataCell(Center(child: Text('13:00'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안터미널(신세계 앞 횡단보도)'))),
                DataCell(Center(child: Text('08:55'))),
                DataCell(Center(child: Text('13:10'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('두정역'))),
                DataCell(Center(child: Text('09:00'))),
                DataCell(Center(child: Text('13:15'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('두정캠퍼스'))),
                DataCell(Center(child: Text('도착'))),
                DataCell(Center(child: Text('도착'))),
                DataCell(Center(child: Text('16:40'))),
                DataCell(Center(child: Text('19:35'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('두정역'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안터미널(신세계 앞 횡단보도)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안역 A(학화 호두과자 앞)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안아산 KTX(3번출구)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('종점'))),
                DataCell(Center(child: Text('종점'))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTable24() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: [
              DataColumn(
                label: Center(
                  child: Text(
                    '승하차장명',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '1회 등교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '2회 하교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              DataColumn(
                label: Center(
                  child: Text(
                    '3회 하교',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Center(child: Text('두정역'))),
                DataCell(Center(child: Text('07:50'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안터미널(신세계 앞 횡단보도)'))),
                DataCell(Center(child: Text('08:00'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안역 A(학화 호두과자 앞)'))),
                DataCell(Center(child: Text('08:05'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text(''))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('본교'))),
                DataCell(Center(child: Text('도착'))),
                DataCell(Center(child: Text('16:20'))),
                DataCell(Center(child: Text('18:10'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안역(태극당 건너 BS)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안역 A(학화 호두과자 앞)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('하차'))),
                DataCell(Center(child: Text('하차'))),
              ]),
              DataRow(cells: [
                DataCell(Center(child: Text('천안터미널(신세계 앞 횡단보도)'))),
                DataCell(Center(child: Text(''))),
                DataCell(Center(child: Text('종점'))),
                DataCell(Center(child: Text('종점'))),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
