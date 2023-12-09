import 'package:flutter/material.dart';
import 'package:unichat/page/list/professorList.dart';
import 'package:unichat/page/profile/professorProfile.dart';
import 'package:unichat/page/profile/studentProfile.dart';
import 'package:unichat/page/reserve/professorReservation.dart';
import 'package:unichat/page/reserve/studentReservation.dart';
import 'package:unichat/user/professor.dart';

import '../page/map/map.dart';
import '../page/map/professorMap.dart';
import '../user/student.dart';

class ProfessorSwipePages extends StatefulWidget {
  Professor professor;

  ProfessorSwipePages(this.professor);

  @override
  _ProfessorSwipePagesState createState() =>
      _ProfessorSwipePagesState(this.professor);
}

class _ProfessorSwipePagesState extends State<ProfessorSwipePages> {
  late Professor professor;
  PageController _controller = PageController(
    initialPage: 0, // 초기 페이지 인덱스 설정
  );
  int _currentPage = 0;

  _ProfessorSwipePagesState(this.professor);

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
            Positioned.fill(
              child: PageView(
                controller: _controller,
                children: <Widget>[
                  ProfessorProfile(professor: professor),
                  ProfessorMapPage(),
                  ProfessorReservation(professorUserId: professor.uid,)
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
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom, // 디바이스 하단의 안전 영역을 고려
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // 가로축의 중앙에 위치시키기 위해 추가
                children: List<Widget>.generate(
                  3, // 전체 페이지 수
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
