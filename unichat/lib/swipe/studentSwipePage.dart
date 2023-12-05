import 'package:flutter/material.dart';
import 'package:unichat/page/map/map.dart';
import 'package:unichat/page/list/professorList.dart';
import 'package:unichat/page/profile/studentProfile.dart';
import 'package:unichat/page/reserve/studentReservation.dart';

import '../user/student.dart';

class StudentSwipePages extends StatefulWidget {
  Student student;
  StudentSwipePages(this.student);

  @override
  _StudentSwipePagesState createState() => _StudentSwipePagesState(this.student);
}

class _StudentSwipePagesState extends State<StudentSwipePages> {
  late Student student;
  PageController _controller = PageController(
    initialPage: 0, // 초기 페이지 인덱스 설정
  );

  _StudentSwipePagesState(this.student);

  @override
  void dispose() {
    _controller.dispose(); // PageController를 dispose 해줍니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          StudentProfile(student: student),
          MapPage(),
          ProfessorList(),
          StudentReservation()

        ],
        onPageChanged: (int page) {
          // 페이지가 변경될 때 실행할 동작
          print("Current Page: $page");
        },
      ),
    );
  }
}
