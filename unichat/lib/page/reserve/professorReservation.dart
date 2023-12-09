import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unichat/page/chat/chatScreen.dart';

import '../../reserveUser/reserveUser.dart';
import '../../user/professor.dart';
import '../../user/student.dart';

class ProfessorReservation extends StatelessWidget {
  String professorUserId;

  ProfessorReservation({super.key, required this.professorUserId});

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
            child: const TextField(
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
                prefixIcon: Icon(Icons.search, color: Colors.grey), // 검색 아이콘 설정
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Expanded(
            child: FutureBuilder<List<ReserveUser>>(
              future: getChatsForProfessor(professorUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // 데이터 로딩 중...
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  // 오류 발생 시
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return ListView(
                  children: snapshot.data!
                      .map((reserveUser) => _buildProfessorRow(context, reserveUser))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildProfessorRow(BuildContext context, ReserveUser reserveUser) {
  // 교수 정보를 Row 위젯으로 표시
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reserveUser.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text(reserveUser.date + " " + reserveUser.time),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ChatScreen(professorId: reserveUser.professorId, studentId: reserveUser.studentId, time: reserveUser.time, date: reserveUser.date),
                )
            );
          },
          icon: Icon(Icons.chat, color: Color(0xFF5DB075)),
        ),
      ],
    ),
  );
}

Future<List<ReserveUser>> getChatsForProfessor(String userId) async {
  QuerySnapshot chatQuerySnapshot = await FirebaseFirestore.instance
      .collection('chat')
      .where('professorId', isEqualTo: userId)
      .get();

  List<ReserveUser> students = [];

  for (var chatDoc in chatQuerySnapshot.docs) {
    print("!@#");
    var chatData = chatDoc.data() as Map<String, dynamic>; // Object를 Map으로 캐스팅
    var professorUserId =
    chatData['studentId']; // 채팅 문서에서 professor의 userId 추출
    print(professorUserId);
    var professorDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(professorUserId)
        .get(); // 해당 userId를 가진 professor의 정보 조회
    Map<String, dynamic> data = professorDoc.data() as Map<String, dynamic>;

    if (professorDoc.exists) {
      students
          .add(ReserveUser(professorUserId, userId, chatData['date'], chatData['time'], data['name'])); // 조회된 정보로 Professor 객체 생성
    }
  }

  return students;
}
