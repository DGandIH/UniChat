import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unichat/page/profile/studentProfile.dart';
import 'package:unichat/swipe/professorSwipePage.dart';
import 'package:unichat/swipe/studentSwipePage.dart';

import '../../signIn/signIn.dart';
import '../image/imageUploader.dart';
import '../user/professor.dart';
import '../user/student.dart';

class ProfessorSignUp extends StatefulWidget {
  ProfessorSignUp({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfessorSignUp();
  }
}

class _ProfessorSignUp extends State {
  final _majorController = TextEditingController();
  final _sectionController = TextEditingController();
  final _wordController = TextEditingController();
  final _imageUploader = ImageUploader();
  XFile? _image;

  final _signIn = SignIn();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF5DB075),
        actions: [
          TextButton(
              onPressed: () async {
                String major = _majorController.text;
                String word = _wordController.text;
                String section = _sectionController.text;
                Professor? professor;

                if(_image != null) {
                  Future<String?> path =
                  _imageUploader.uploadImageToFirebase(_image);

                  String? uploadPath = await path;
                  await _imageUploader.saveImageUrlToFirestore(uploadPath!);


                  professor = await _signIn.addProfessorCollection(major, word, section, uploadPath);
                } else {
                  professor = await _signIn.addProfessorCollection(major, word, section, "https://firebasestorage.googleapis.com/v0/b/unichat-d6dd5.appspot.com/o/uploads%2Flogo.png?alt=media&token=fcf72899-8e3c-41b1-b6d0-054fc225f8d4");
                }


                if(professor != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfessorSwipePages(professor!),
                      ));
                }

              },
              child: const Icon(
                Icons.login,
                color: Colors.white,
              )),
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
                                child: _image == null
                                    ? Image(
                                  image: AssetImage("assets/logo.png"),
                                )
                                    : Image.file(File(_image!.path)))),
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
                      FirebaseAuth.instance.currentUser?.displayName ?? '이름',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.1,
                          fontWeight: FontWeight.w800),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.025),
                              Expanded(
                                  child: TextButton(
                                    onPressed: () async {

                                      Future<XFile?> image = _imageUploader.getData();
                                      XFile? uploadImage = await image;

                                      if (uploadImage != null) {
                                        setState(() {
                                          _image = uploadImage;
                                          print(_image?.name);
                                        });
                                      }
                                    },
                                    child: Text(
                                      "사진 추가하기",
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),
                                    ),
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.025),
                              Expanded(
                                  child: TextField(
                                    decoration:
                                    const InputDecoration(hintText: "소속 학부를 입력하세요"),
                                    style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),
                                    controller: _sectionController,
                                  )),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.025),
                              Expanded(
                                child: TextField(
                                  decoration:
                                  const InputDecoration(hintText: "전공을 입력하세요"),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),
                                  controller: _majorController,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.025),
                              Expanded(
                                child: TextField(
                                  decoration:
                                  const InputDecoration(hintText: "하고싶은 말을 입력하세요"),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),
                                  controller: _wordController,
                                ),
                              ),
                            ],
                          ),
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
