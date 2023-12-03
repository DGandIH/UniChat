import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableTimeForm extends StatefulWidget {
  @override
  _AvailableTimeFormState createState() => _AvailableTimeFormState();
}

class _AvailableTimeFormState extends State<AvailableTimeForm> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  List<String> reservedTimes = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _loadReservedTimes();
  }

  Future<void> _loadReservedTimes() async {
    // Firestore에서 선택한 날짜의 예약된 시간대 목록을 읽어옵니다.
    var selectedDateStr = "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";
    var collection = FirebaseFirestore.instance.collection('reservations');
    var snapshot = await collection.doc(selectedDateStr).get();
    if (snapshot.exists && snapshot.data() != null) {
      setState(() {
        reservedTimes = List<String>.from(snapshot.data()!['times']);
      });
    } else {
      setState(() {
        reservedTimes = [];
      });
    }
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
        _loadReservedTimes(); // 날짜가 변경되면 예약된 시간을 다시 읽어옵니다.
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime = (await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    ))!;
    if (pickedTime != null && pickedTime != _selectedTime) {
      final selectedTimeString = '${pickedTime.hour}:${pickedTime.minute}';
      if (!reservedTimes.contains(selectedTimeString)) {
        setState(() {
          _selectedTime = pickedTime;
        });
      } else {
        // 예약된 시간대를 선택하려고 할 때 경고 표시 또는 처리 방법을 추가하세요.
        // 예를 들어, ScaffoldMessenger를 사용하여 경고 메시지를 표시할 수 있습니다.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('This time slot is already reserved.'),
        ));
      }
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
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Select Time'),
            ),
            Text('Selected Time: ${_selectedTime.format(context)}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 여기에서 _selectedDate와 _selectedTime을 사용하여 처리합니다.
                // 예를 들어, Firestore에 저장하거나 다른 작업을 수행할 수 있습니다.
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
