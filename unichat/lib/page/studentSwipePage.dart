import 'package:flutter/material.dart';
import 'package:unichat/page/map/map.dart';
import 'package:unichat/page/profile/studentProfile.dart';

import '../user/student.dart';

class MySwipePages extends StatefulWidget {
  Student student;
  MySwipePages(this.student);

  @override
  _MySwipePagesState createState() => _MySwipePagesState(this.student);
}

class _MySwipePagesState extends State<MySwipePages> {
  late Student student;
  PageController _controller = PageController(
    initialPage: 0, // 초기 페이지 인덱스 설정
  );

  _MySwipePagesState(this.student);

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
          MapPage()

        ],
        onPageChanged: (int page) {
          // 페이지가 변경될 때 실행할 동작
          print("Current Page: $page");
        },
      ),
    );
  }
}
