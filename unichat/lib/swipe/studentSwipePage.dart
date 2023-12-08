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
  _StudentSwipePagesState createState() =>
      _StudentSwipePagesState(this.student);
}

class _StudentSwipePagesState extends State<StudentSwipePages> {
  late Student student;
  int _currentPage = 0;
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
      body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
        PageView(
          controller: _controller,
          children: <Widget>[
            StudentProfile(student: student),
            MapPage(),
            ProfessorList(),
            StudentReservation(
              studentId: student.uid,
            )
          ],
          onPageChanged: (int page) {
            setState(() {
              if (mounted) {
                setState(() {
                  _currentPage = page;
                });
              }
            });
            print("Current Page: $page");
          },
        ),
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom, // 디바이스 하단의 안전 영역을 고려
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // 가로축의 중앙에 위치시키기 위해 추가
            children: List<Widget>.generate(
              4, // 전체 페이지 수
              (int index) => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: 10,
                width: _currentPage == index ? 30 : 10,
                // 현재 페이지 표시를 위해 너비 변경
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
