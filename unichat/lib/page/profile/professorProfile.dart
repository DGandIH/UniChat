import 'package:flutter/material.dart';

import '../../signIn/signIn.dart';
import '../../user/professor.dart';

class ProfessorProfile extends StatelessWidget {
  final _signIn = SignIn();
  Professor professor;

  ProfessorProfile({super.key, required this.professor});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF5DB075),
        leading: TextButton(
            onPressed: () {
              _signIn.signOUt();
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            )),
        actions: [
          TextButton(
              onPressed: () {
                _signIn.signOUt();
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ))
        ],
        title: const Text(
          "교수님 프로필",
          style: TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2, // 상단 영역이 하단 영역보다 높은 비율로 차지하게 설정
            child: Container(
                color: const Color(0xFF5DB075), // 상단 컨테이너 색상
                child: Center(
                  child: Stack(
                    alignment: Alignment.center, // 스택 내의 위젯들을 중앙 정렬
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, MediaQuery.of(context).size.width * 0.005, 0, 0),
                        child: ClipOval(
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height:
                                MediaQuery.of(context).size.width * 0.45,
                                color: Colors.white,
                                child: Image(
                                  image: NetworkImage(professor.imagePath),
                                ))),
                      ),
                    ],
                  ),
                )),
          ),
          Expanded(
            flex: 6, // 하단 영역이 상단 영역보다 더 큰 비율로 차지하게 설정
            child: Container(
              color: Colors.white, // 하단 컨테이너 색상
              child: Column(
                children: [
                  SizedBox(
                    width: 0,
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  Text(
                    professor.name,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.1,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(professor.email,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.08, 0, MediaQuery.of(context).size.width * 0.08, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.circle, size: 20,),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                            const Text("소속 학부", style: TextStyle(fontSize: 20),),
                            const Spacer(),
                            Text(professor.department, style: TextStyle(fontSize: 20),),
                          ],
                        ),
                        const Divider(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                        Row(
                          children: [
                            const Icon(Icons.circle, size: 20,),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                            const Text("전공", style: TextStyle(fontSize: 20),),
                            const Spacer(),
                            Text(professor.major, style: TextStyle(fontSize: 20),),
                          ],
                        ),
                        const Divider(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                        Row(
                          children: [
                            const Icon(Icons.circle, size: 20,),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                            const Text("하고싶은 말", style: TextStyle(fontSize: 20),),
                            const Spacer(),
                            Text(professor.words, style: TextStyle(fontSize: 20),),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
