import 'package:flutter/material.dart';

class CitybusPage extends StatefulWidget {
  const CitybusPage({super.key});

  @override
  State<CitybusPage> createState() => _CitybusPageState();
}

class _CitybusPageState extends State<CitybusPage> {
  final Map<String, Map<String, List<String>>> busSchedules = {
    '400번': {
      '병천3리 방면': [
        '06:00',
        '06:16',
        '06:32',
        '06:48',
        '07:04',
        '07:20',
        '07:36',
        '07:52',
        '08:08',
        '08:24',
        '08:40',
        '08:56',
        '09:12',
        '09:28',
        '09:44',
        '10:00',
        '10:16',
        '10:32',
        '10:48',
        '11:04',
        '11:20',
        '11:36',
        '11:52',
        '12:08',
        '12:24',
        '12:40',
        '12:56',
        '13:12',
        '13:28',
        '13:44',
        '14:00',
        '14:16',
        '14:32',
        '14:48',
        '15:04',
        '15:20',
        '15:36',
        '15:52',
        '16:08',
        '16:24',
        '16:40',
        '16:56',
        '17:12',
        '17:28',
        '17:44',
        '18:00',
        '18:16',
        '18:32',
        '18:48',
        '19:04',
        '19:20',
        '19:36',
        '19:52',
        '20:10',
        '20:30',
        '20:50',
        '21:10',
        '21:35',
        '22:00',
        '22:30'
      ],
      '종합터미널 방면': [
        '06:10',
        '06:30',
        '06:50',
        '07:05',
        '07:21',
        '07:37',
        '07:53',
        '08:09',
        '08:20',
        '08:30',
        '08:46',
        '09:02',
        '09:18',
        '09:34',
        '09:50',
        '10:06',
        '10:22',
        '10:38',
        '10:54',
        '11:10',
        '11:26',
        '11:42',
        '11:58',
        '12:14',
        '12:30',
        '12:46',
        '13:02',
        '13:18',
        '13:34',
        '13:50',
        '14:06',
        '14:22',
        '14:38',
        '14:54',
        '15:10',
        '15:26',
        '15:42',
        '15:58',
        '16:14',
        '16:30',
        '16:46',
        '17:02',
        '17:18',
        '17:34',
        '17:50',
        '18:06',
        '18:22',
        '18:38',
        '18:54',
        '19:10',
        '19:26',
        '19:42',
        '19:58',
        '20:14',
        '20:30',
        '20:46',
        '21:02',
        '21:20',
        '21:40',
        '22:00',
        '22:20',
        '22:40'
      ]
    },
    '402번': {
      '황사동 방면': [
        '06:05',
        '17:30'
      ],
      '종합터미널 방면': [
        '07:10',
        '18:40'
      ]
    },
    '405번': {
      '유관순열사유적지 방면': [
        '06:10',
        '06:55',
        '07:40',
        '08:30',
        '09:05',
        '09:55',
        '10:40',
        '11:30',
        '12:15',
        '13:05',
        '13:35',
        '14:25',
        '15:10',
        '16:00',
        '16:45',
        '17:35',
        '18:10',
        '18:55',
        '19:45',
        '20:40',
        '21:20',
        '22:10',
        '22:40'
      ],
      '종합터미널 방면': [
        '06:25',
        '07:10',
        '07:55',
        '08:40',
        '09:30',
        '10:05',
        '10:55',
        '11:40',
        '12:30',
        '13:15',
        '14:05',
        '14:35',
        '15:25',
        '16:10',
        '17:00',
        '17:45',
        '18:35',
        '19:10',
        '19:55',
        '20:45',
        '21:35'
      ]
    },
  };

  String? selectedBus;
  String? selectedDirection;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('시내버스 시간표'),
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
                      hint: Text('버스 번호를 선택하세요'),
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
                          hint: Text('방향을 선택하세요'),
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
              Expanded(child: _buildScheduleTable())
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleTable() {
    List<String> schedule = busSchedules[selectedBus]![selectedDirection]!;
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: DataTable(
            columns: [
              DataColumn(label: Text('평일 출발시간', style: TextStyle(color: Color(0xff30619c), fontWeight: FontWeight.w600),)),
              DataColumn(label: Text('주말 출발시간', style: TextStyle(color: Color(0xff30619c), fontWeight: FontWeight.w600),)),
              DataColumn(label: Text('공휴일 출발시간', style: TextStyle(color: Color(0xff30619c), fontWeight: FontWeight.w600),)),
              DataColumn(label: Text('임시 출발시간', style: TextStyle(color: Color(0xff30619c), fontWeight: FontWeight.w600),)),
            ],
            rows: List<DataRow>.generate(
              schedule.length,
              (index) => DataRow(cells: [
                DataCell(Center(child: Text(schedule[index]))),
                DataCell(Center(child: Text(schedule[index]))),
                DataCell(Center(child: Text(schedule[index]))),
                DataCell(Center(child: Text(schedule[index]))),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
