import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unichat/signIn/studentSignUp.dart';
import 'package:unichat/swipe/studentSwipePage.dart';

import '../../signIn/signIn.dart';
import '../../user/student.dart';
import '../profile/studentProfile.dart';

class StudentLoginPage extends StatelessWidget {
  StudentLoginPage({Key? key}) : super(key: key);
  final _signIn = SignIn();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "학생 로그인",
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

                  // 로그인에 성공했는지 확인
                  if (userCredential.user != null) {
                    print('로그인 성공: ${userCredential.user!.email}');

                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                    DocumentReference userDocRef = firestore.collection('user').doc(FirebaseAuth.instance.currentUser!.uid);
                    DocumentSnapshot userDocSnapshot = await userDocRef.get();

                    if(userDocSnapshot.exists) {
                      Student user = Student.fromDocument(userDocSnapshot);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentSwipePages(user),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentSignUp(),
                          ));
                    }


                    // QuerySnapshot querySnapshot = await userCollectionRef
                    //     .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    //     .get();
                    
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
