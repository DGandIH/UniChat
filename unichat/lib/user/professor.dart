import 'package:cloud_firestore/cloud_firestore.dart';

class Professor {
  String email;
  String name;
  String uid;
  String major;
  String MBTI;
  String words;
  String department;

  Professor(
      {required this.email,
      required this.name,
      required this.uid,
      required this.major,
      required this.MBTI,
      required this.department,
      required this.words});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'uid': uid,
      'major': major,
      'MBTI': MBTI,
      'department': department,
      'words': words
    };
  }

  factory Professor.fromDocument(DocumentSnapshot doc) {
    return Professor(
      name: doc['name'],
      department: doc['department'],
      email: doc['email'],
      uid: doc['uid'],
      major: doc['major'],
      MBTI: doc['MBTI'],
      words: doc['words'],
    );
  }
}
