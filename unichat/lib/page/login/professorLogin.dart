import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unichat/signIn/professorSignUp.dart';
import 'package:unichat/swipe/professorSwipePage.dart';
import 'package:unichat/user/professor.dart';

import '../../signIn/signIn.dart';

class ProfessorLoginPage extends StatelessWidget {
  ProfessorLoginPage({Key? key}) : super(key: key);
  final _signIn = SignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "교수님 로그인",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential =
                  await _signIn.signInWithGoogle();

                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                  DocumentReference userDocRef = firestore.collection('professor').doc(FirebaseAuth.instance.currentUser!.uid);
                  DocumentSnapshot userDocSnapshot = await userDocRef.get();

                  if(userDocSnapshot.exists) {
                    Professor user = Professor.fromDocument(userDocSnapshot);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfessorSwipePages(user),
                        ));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfessorSignUp(),
                        ));
                  }


                } on FirebaseAuthException catch (e) {
                  // Firebase 인증 에러 처리
                  print('로그인 실패: ${e.message}');
                } catch (e) {
                  // 기타 에러 처리
                  print('에러 발생: $e');
                }
              },
              child: Text(
                'Google',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(const Color(0xFF5DB075)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
