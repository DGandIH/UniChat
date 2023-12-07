import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableTimeForm extends StatefulWidget {
  @override
  _AvailableTimeFormState createState() => _AvailableTimeFormState();
}

class _AvailableTimeFormState extends State<AvailableTimeForm> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  String? _selectedTimeStr;
  List<String> availableTimes = [];
  List<String> reservedTimes = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _initializeAvailableTimes();
    _loadAvailableTimes().then((_) {
      if (availableTimes.isNotEmpty) {
        setState(() {
          _selectedTimeStr = availableTimes.first; // 안전한 초기값 설정
        });
      }
    });
  }

  void _initializeAvailableTimes() {
    List<String> times = [];
    for (int hour = 0; hour < 24; hour++) {
      String hourFormatted = hour.toString().padLeft(2, '0');
      times.add("$hourFormatted:00");
    }
    setState(() {
      availableTimes = times;
    });
  }

  TimeOfDay _getTimeFromString(String timeStr) {
    final hours = int.parse(timeStr.split(':')[0]);
    final minutes = int.parse(timeStr.split(':')[1]);
    return TimeOfDay(hour: hours, minute: minutes);
  }

  Future<void> _loadAvailableTimes() async {
    var selectedDateStr = "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    var availableTimesCollection = FirebaseFirestore.instance.collection('available_times');

    var querySnapshot = await availableTimesCollection.where('uid', isEqualTo: currentUserId).get();
    var userReservedTimes = querySnapshot.docs
        .where((doc) => doc.data()['date'] == selectedDateStr)
        .map((doc) => doc.data()['time'])
        .toList();

    print("userReservedTimes");
    print(userReservedTimes);
    print("availableTimes");
    print(availableTimes);

    setState(() {
      availableTimes = availableTimes.where((time) => !userReservedTimes.contains(time)).toList();
      print(availableTimes);
    });
  }

  Future<void> _saveAvailableTime() async {
    var selectedDateStr = "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";
    // var selectedTimeStr = "${_selectedTime.hour}:${_selectedTime.minute}";

    var selectedTimeStr = "${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}";
    // var availableTimesCollection = FirebaseFirestore.instance.collection('available_times');
    // var availableSnapshot = await availableTimesCollection.doc(selectedDateStr).get();

    // if (availableSnapshot.exists) {
    //   List<String> times = List<String>.from(availableSnapshot.data()!['times']);
    //   if (times.contains(selectedTimeStr)) {
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text('This time slot is already booked.'),
    //     ));
    //     return;
    //   }
    // }

    String? uid = FirebaseAuth.instance.currentUser?.uid;
    var docRef = FirebaseFirestore.instance.collection('available_times').doc();
    await docRef.set({
      'uid': uid,
      'date': selectedDateStr,
      'time': selectedTimeStr
    });

    var snapshot = await docRef.get();

    // if (snapshot.exists && snapshot.data()!['times'] != null) {
    //   List<String> times = List<String>.from(snapshot.data()!['times']);
    //   if (!times.contains(selectedTimeStr)) {
    //     times.add(selectedTimeStr);
    //     await docRef.update({'times': times});
    //   }
    // } else {
    //   await docRef.set({
    //     'times': [selectedTimeStr]
    //   });
    // }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ))!;
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _loadAvailableTimes(); // 날짜가 변경되면 예약된 시간을 다시 읽어옵니다.
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    var selectedTimeString = '${_selectedTime.hour}:${_selectedTime.minute}';
    var selectedDateStr = "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";

    var availableTimesCollection = FirebaseFirestore.instance.collection('available_times');
    var availableSnapshot = await availableTimesCollection.doc(selectedDateStr).get();

    if (availableSnapshot.exists) {
      List<String> times = List<String>.from(availableSnapshot.data()!['times']);
      if (times.contains(selectedTimeString)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('This time slot is already booked.'),
        ));
        return;
      }
    }

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.hm,
            initialTimerDuration: Duration(hours: _selectedTime.hour, minutes: _selectedTime.minute),
            onTimerDurationChanged: (Duration changedTimer) {
              setState(() {
                _selectedTime = TimeOfDay(hour: changedTimer.inHours, minute: changedTimer.inMinutes % 60);
              });
            },
          ),
        );
      },
    );


    if (!reservedTimes.contains(selectedTimeString)) {
      setState(() {
        _selectedTime = TimeOfDay(hour: _selectedTime.hour, minute: _selectedTime.minute);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('This time slot is already reserved.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Reservation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
            Text('Selected Date: ${_selectedDate.toLocal()}'),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedTimeStr,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTime = _getTimeFromString(newValue!);
                  _selectedTimeStr = newValue;
                });
              },
              items: availableTimes
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            if (_selectedTimeStr != null)
              Text('Selected Time: ${_selectedTime.format(context)}'),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveAvailableTime();
                Navigator.pop(context);
              },
              child: Text('Complete'),
            ),
          ],
        ),
      ),
    );
  }
}


