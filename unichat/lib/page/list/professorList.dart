import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../user/professor.dart';

class ProfessorList extends StatelessWidget {
  const ProfessorList({super.key});

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
                0
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                // 나머지 decoration 설정...
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.025),
          Expanded(
            child: FutureBuilder<List<Professor>> (
              future: getProfessors(),
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
                  children: snapshot.data!.map((professor) => _buildProfessorRow(context, professor)).toList(),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}

Widget _buildProfessorRow(BuildContext context, Professor professor) {
  // 교수 정보를 Row 위젯으로 표시
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(professor.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text(professor.words),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // 클릭 이벤트 처리
          },
          icon: Icon(Icons.chat, color: Color(0xFF5DB075)),
        ),
      ],
    ),
  );
}


Future<List<Professor>> getProfessors() async { // professor 객체에 있는 모든 값들을 다 가지고 옴
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('professor').get();

  return querySnapshot.docs.map((doc) {
    return Professor.fromDocument(doc);
  }).toList();
}
