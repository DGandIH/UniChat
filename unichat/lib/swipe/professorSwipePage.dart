import 'package:flutter/material.dart';
import 'package:unichat/page/list/professorList.dart';
import 'package:unichat/page/profile/professorProfile.dart';
import 'package:unichat/page/profile/studentProfile.dart';
import 'package:unichat/page/reserve/studentReservation.dart';
import 'package:unichat/user/professor.dart';

import '../page/map/map.dart';
import '../user/student.dart';

class ProfessorSwipePages extends StatefulWidget {
  Professor professor;
  ProfessorSwipePages(this.professor);

  @override
  _ProfessorSwipePagesState createState() => _ProfessorSwipePagesState(this.professor);
}

class _ProfessorSwipePagesState extends State<ProfessorSwipePages> {
  late Professor professor;
  PageController _controller = PageController(
    initialPage: 0, // 초기 페이지 인덱스 설정
  );

  _ProfessorSwipePagesState(this.professor);

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
          ProfessorProfile(professor: professor),
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
