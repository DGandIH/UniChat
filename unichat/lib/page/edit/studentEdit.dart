

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unichat/swipe/studentSwipePage.dart';
import 'package:unichat/user/student.dart';

import '../../image/imageUploader.dart';
import '../../signIn/signIn.dart';
import '../../swipe/professorSwipePage.dart';
import '../../user/professor.dart';

class StudentEditPage extends StatefulWidget {
  Student student;

  StudentEditPage({super.key, required this.student});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StudentEditState(student: student);
  }
}

class _StudentEditState extends State {
  Student student;
  late TextEditingController _majorController;
  late TextEditingController _mbtiController;
  late TextEditingController _studentIdController;
  _StudentEditState({required this.student});

  final _imageUploader = ImageUploader();
  XFile? _image;

  @override
  void initState() {
    super.initState();
    _majorController = TextEditingController(text: student.major);
    _mbtiController = TextEditingController(text: student.MBTI);
    _studentIdController = TextEditingController(text: student.studentId);
  }

  final _signIn = SignIn();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF5DB075),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                String major = _majorController.text;
                String mbti = _mbtiController.text;
                String studentId = _studentIdController.text;
                Student? student;

                if(_image != null) {
                  Future<String?> path =
                  _imageUploader.uploadImageToFirebase(_image);

                  String? uploadPath = await path;
                  await _imageUploader.saveImageUrlToFirestore(uploadPath!);


                  student = await _signIn.updateStudentProfile(FirebaseAuth.instance.currentUser!.uid, studentId, major, mbti, uploadPath);
                } else {
                  student = await _signIn.updateStudentProfile(FirebaseAuth.instance.currentUser!.uid, studentId, major, mbti, student!.imagePath);
                }

                if(student != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            StudentSwipePages(student!),
                      ));
                }

              },
              icon: Icon(
                Icons.upload,
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
                                  image: NetworkImage(student.imagePath),
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
                                  const InputDecoration(hintText: "학번을 입력하세요"),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),
                                  controller: _studentIdController,
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
                                  const InputDecoration(hintText: "mbti를 입력하세요"),
                                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05,),
                                  controller: _mbtiController,
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
