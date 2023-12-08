import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unichat/page/calendar/availableTime.dart';
import 'package:unichat/page/chat/chatScreen.dart';

import '../../user/professor.dart';

class ProfessorCalendarPage extends StatefulWidget {
  Professor professor;

  ProfessorCalendarPage({super.key, required this.professor});
  @override
  _ProfessorCalendarPageState createState() => _ProfessorCalendarPageState();
}

class _ProfessorCalendarPageState extends State<ProfessorCalendarPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  List<String> availableTimes = [];
  String professorId = "pdxUFz6KD0Pp5WGPwgB7isyQiZ62";

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _calendarFormat = CalendarFormat.month;
    _retrieveAvailableTimes(_selectedDay, professorId); // initState에서도 호출
    // _updateAvailableTimes(_selectedDay);
  }

  // _retrieveAvailableTimes(DateTime selectedDay) async {
  //   var selectedDateStr = "${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day}";
  //   var collection = FirebaseFirestore.instance.collection('available_times');
  //   var snapshot = await collection.doc(selectedDateStr).get();
  //   if (snapshot.exists && snapshot.data() != null) {
  //     setState(() {
  //       availableTimes = List<String>.from(snapshot.data()!['times']);
  //     });
  //   } else {
  //     setState(() {
  //       availableTimes = [];
  //     });
  //   }
  // }

  _retrieveAvailableTimes(DateTime selectedDay, String uid) async {
    // 선택된 날짜를 문자열로 변환합니다.
    var selectedDateStr = "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}";
    // Firestore의 'available_times' 컬렉션을 참조합니다.
    var collection = FirebaseFirestore.instance.collection('available_times');
    // 선택된 날짜의 문서 ID를 사용하여 Firestore에서 데이터를 검색합니다.
    var snapshot = await collection
        .where('date', isEqualTo: selectedDateStr)
        .where('uid', isEqualTo: uid)
        .get();
    // 스냅샷에 데이터가 있으면 해당 데이터로 availableTimes를 업데이트합니다.
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        // 가져온 문서들에서 'time' 필드의 값을 추출하여 availableTimes 리스트에 추가합니다.
        availableTimes = snapshot.docs
            .map((doc) => doc.data()['time'] as String)
            .toList();
      });
    } else {
      setState(() {
        availableTimes = []; // 데이터가 없으면 빈 리스트로 설정합니다.
      });
    }
  }


  void _updateAvailableTimes(DateTime date) {
    // 여기에 더미 데이터를 정의합니다.
    // 예를 들어, 모든 날짜에 대해 동일한 예약 시간을 제공할 수 있습니다.
    var dummyTimes = [
      '09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM', '02:00 PM'
    ];

    setState(() {
      availableTimes = dummyTimes;
    });
  }

  void _navigateToForm() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          // ReservationForm을 사용하여 폼 화면을 렌더링합니다.
          return AvailableTimeForm();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Flutter Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarBuilders: CalendarBuilders(
              // 현재 날짜에 대한 커스텀 빌더를 정의합니다.
              defaultBuilder: (context, day, focusedDay) {
                if (isSameDay(day, DateTime.now())) {
                  // 현재 날짜에 대한 스타일을 여기에 정의합니다.
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                // 다른 날짜들에 대해서는 기본 스타일을 사용합니다.
                return null;
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _retrieveAvailableTimes(selectedDay, professorId); // 여기서 함수 호출
              // _retrieveAvailableTimes();
              // _updateAvailableTimes(selectedDay);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: availableTimes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(availableTimes[index]),
                  onTap: () {
                    // 나중에 페이지 연결
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ReservationDetailsPage(
                    //       selectedDate: _selectedDay,
                    //       selectedTime: availableTimes[index
                    //     ),
                    //   ),
                    // );

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           // ChatScreen(professorId: professorId),
                    //     ));

                    print("${_selectedDay}\n");
                    print("${availableTimes[index]}\n");
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToForm,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // 오른쪽 하단 위치
    );
  }
}
