import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StudentCalendarPage extends StatefulWidget {
  @override
  _StudentCalendarPageState createState() => _StudentCalendarPageState();
}

class _StudentCalendarPageState extends State<StudentCalendarPage> {
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
    // _retrieveAvailableTimes();
    _updateAvailableTimes(_selectedDay);
  }

  _retrieveAvailableTimes() async {
    // Firestore에서 선택된 날짜의 예약 가능한 시간을 가져옵니다.
    var selectedDateStr = "${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day}";
    var collection = FirebaseFirestore.instance.collection('reservations');
    var snapshot = await collection.doc(selectedDateStr).get();
    if (snapshot.exists && snapshot.data() != null) {
      setState(() {
        availableTimes = List<String>.from(snapshot.data()!['times']);
      });
    } else {
      setState(() {
        availableTimes = [];
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
              // _retrieveAvailableTimes();
              _updateAvailableTimes(selectedDay);
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
                    //       selectedTime: availableTimes[index],
                    //     ),
                    //   ),
                    // );
                    print("${_selectedDay}\n");
                    print("${availableTimes[index]}\n");
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
