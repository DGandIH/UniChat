import 'package:flutter/material.dart';

import '../../signIn/signIn.dart';

class StudentSignUp extends StatefulWidget {
  StudentSignUp({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StudentSignUpState();
  }
}

class _StudentSignUpState extends State {
  final _studentIdController = TextEditingController();
  final _majorController = TextEditingController();
  final _mbtiController = TextEditingController();

  final _signIn = SignIn();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF5DB075),
        leading: TextButton(
            onPressed: () {
              _signIn.signOUt();
              // 여기서 가입하는 부분으로 넘어가는 로직을 짜야함
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.login,
              color: Colors.white,
            )),
        title: const Text(
          "프로필",
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
                                child: const Image(
                                  image: AssetImage("assets/logo.png"),
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
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.08,
                    0,
                    MediaQuery.of(context).size.width * 0.08,
                    0),
                child: Column(
                  children: [
                    SizedBox(
                      width: 0,
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    Text(
                      "이름",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.1,
                          fontWeight: FontWeight.w800),
                    ),
                    Expanded(
                      child: TextField(
                          controller: _studentIdController,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 20,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.025),
                              const Text(
                                "전공",
                                style: TextStyle(fontSize: 20),
                              ),
                              const Spacer(),
                              Expanded(
                                  child: TextField(
                                style: TextStyle(fontSize: 20),
                                controller: _majorController,
                              )),
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              const Icon(
                                Icons.circle,
                                size: 20,
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.025),
                              const Text(
                                "MBTI",
                                style: TextStyle(fontSize: 20),
                              ),
                              const Spacer(),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(fontSize: 20),
                                  controller: _mbtiController,
                                ),
                              ),
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
          ),
        ],
      ),
    );
  }
}
