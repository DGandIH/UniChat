import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../signIn/signIn.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final _signIn = SignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.coffee, size: 40,), Text("Log-in", style: TextStyle(fontSize: 35),)],
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
                    _signIn.addUserCollection();

                    Navigator.pushNamed(context, "/profile");
                  }
                } on FirebaseAuthException catch (e) {
                  // Firebase 인증 에러 처리
                  print('로그인 실패: ${e.message}');
                } catch (e) {
                  // 기타 에러 처리
                  print('에러 발생: $e');
                }
              },
              child: Text('Google', style: TextStyle(color: Colors.white),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color(0xFF5DB075)),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                try {
                  // signInWithGoogle 함수를 호출하여 로그인 시도
                  UserCredential userCredential =
                  await _signIn.signInAnonymously();
                  _signIn.addUserCollection();

                } on FirebaseAuthException catch (e) {
                  print("error");
                }
              },
              child: Text('Guest', style: TextStyle(color: Colors.black),),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
