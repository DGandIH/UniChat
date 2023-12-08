

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentReservation extends StatelessWidget {
  const StudentReservation({super.key});

  final String studentId = "pdxUFz6KD0Pp5WGPwgB7isyQiZ62";

  Stream<List<String>> getProfessorIds() {
    return FirebaseFirestore.instance
        .collection('chat')
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc['professorId'] as String).toList());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: SizedBox(
          // SizedBox를 사용하여 크기를 조정합니다.
          height: 50.0, // 원하는 높이로 설정
          width: 50.0, // 원하는 너비로 설정
          child: Image.asset("assets/coffee.png"),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.08,
                MediaQuery.of(context).size.height * 0.05,
                MediaQuery.of(context).size.width * 0.08,
                0),
            child: Column(
              children: [
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    // 힌트 텍스트 설정
                    filled: true,
                    // 배경색을 채우기 위해 true로 설정
                    fillColor: Color(0xffE8E8E8),
                    // 배경색을 흰색으로 설정
                    border: OutlineInputBorder(
                      // 테두리 설정
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      // 둥근 모서리의 반경 설정
                      borderSide: BorderSide.none, // 테두리 선을 없앰
                    ),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    // 내부 패딩 설정
                    prefixIcon:
                    Icon(Icons.search, color: Colors.grey), // 검색 아이콘 설정
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child:
                        const Image(image: AssetImage("assets/logo.png"))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "조성배 교수님",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text("23/12/20 09:00 - 10:00"),
                      ],
                    ),
                    Spacer(),
                    IconButton(onPressed: () {
                      Navigator.pushNamed(context, "/professor/student");
                    }, icon: Icon(Icons.chat, color: Color(0xFF5DB075),))
                  ],
                ),
                Divider(
                  indent: MediaQuery.of(context).size.width * 0.23,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child:
                        const Image(image: AssetImage("assets/logo.png"))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "남재창 교수님",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text("23/12/20 09:00 - 10:00"),
                      ],
                    ),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.chat, color: Color(0xFF5DB075),))
                  ],
                ),
                Divider(
                  indent: MediaQuery.of(context).size.width * 0.23,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child:
                        const Image(image: AssetImage("assets/logo.png"))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "홍신 교수님",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text("23/12/20 09:00 - 10:00"),
                      ],
                    ),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.chat, color: Color(0xFF5DB075),))
                  ],
                ),
                Divider(
                  indent: MediaQuery.of(context).size.width * 0.23,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child:
                        const Image(image: AssetImage("assets/logo.png"))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "용환기 교수님",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text("23/12/20 09:00 - 10:00"),
                      ],
                    ),
                    Spacer(),
                    IconButton(onPressed: () {}, icon: Icon(Icons.chat, color: Color(0xFF5DB075),))
                  ],
                ),
                Divider(
                  indent: MediaQuery.of(context).size.width * 0.23,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

}