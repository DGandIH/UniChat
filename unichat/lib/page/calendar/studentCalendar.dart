import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unichat/page/chat/chatScreen.dart';

import '../../user/professor.dart';

class StudentCalendarPage extends StatefulWidget {
  Professor professor;
  String studentUserId;

  StudentCalendarPage({super.key, required this.professor, required this.studentUserId});

  @override
  _StudentCalendarPageState createState() => _StudentCalendarPageState();
}

class _StudentCalendarPageState extends State<StudentCalendarPage>  {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  List<String> availableTimes = [];


  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _calendarFormat = CalendarFormat.month;
    print("Professor's UID: ${widget.professor.uid}");
    _retrieveAvailableTimes(_selectedDay, widget.professor.uid);

  }

  _retrieveAvailableTimes(DateTime selectedDay, String uid) async {
    var selectedDateStr = "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}";
    var availableTimesCollection = FirebaseFirestore.instance.collection('available_times');
    var reservationsCollection = FirebaseFirestore.instance.collection('reservations');

    var reservedSnapshot = await reservationsCollection
        .where('date', isEqualTo: selectedDateStr)
        .where('professorId', isEqualTo: widget.professor.uid) // 여기에 professorId 필터를 추가합니다.
        .get();

    List<String> reservedTimes = reservedSnapshot.docs
        .map((doc) => doc.data()['time'] as String)
        .toList();

    print("rt");
    print(reservedTimes);

    var availableSnapshot = await availableTimesCollection
        .where('date', isEqualTo: selectedDateStr)
        .where('uid', isEqualTo: uid)
        .get();

    if (availableSnapshot.docs.isNotEmpty) {
      setState(() {
        availableTimes = availableSnapshot.docs
            .map((doc) => doc.data()['time'] as String)
            .where((time) => !reservedTimes.contains(time))
            .toList();
      });
    } else {
      setState(() {
        availableTimes = []; // 데이터가 없으면 빈 리스트로 설정합니다.
      });
    }

    print("at");
    print(availableTimes);
  }


  void _updateAvailableTimes(DateTime date) {
    var dummyTimes = [
      '09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM', '02:00 PM'
    ];

    setState(() {
      availableTimes = dummyTimes;
    });
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
              _retrieveAvailableTimes(selectedDay, widget.professor.uid); // 여기서 함수 호출
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
                  onTap: () async {
                    // String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
                    var selectedDateStr = "${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day}";
                    await FirebaseFirestore.instance.collection('reservations').add({
                      'date': selectedDateStr, // 날짜를 문자열로 변환
                      'time': availableTimes[index], // 선택된 시간
                      'studentId': widget.studentUserId, // 학생 ID
                      'professorId': widget.professor.uid, // 교수 ID
                    });

                    await FirebaseFirestore.instance.collection('chat').add({
                      'professorId': widget.professor.uid,
                      'studentId': widget.studentUserId,
                      'date': selectedDateStr, // 날짜를 문자열로 변환
                      'time': availableTimes[index], // 선택된 시간
                    });

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(targetId: widget.professor.uid, curId: widget.studentUserId, time: availableTimes[index], date: selectedDateStr, professorId: widget.professor.uid,
                              studentId: widget.studentUserId),
                        )
                    );

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
