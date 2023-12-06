import 'package:cloud_firestore/cloud_firestore.dart';

class Professor {
  String email;
  String name;
  String uid;
  String major;
  String words;
  String department;
  String imagePath;

  Professor(
      {required this.email,
      required this.name,
      required this.uid,
      required this.major,
      required this.department,
        required this.imagePath,
      required this.words});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'uid': uid,
      'major': major,
      'department': department,
      'words': words,
      'imagePath' : imagePath
    };
  }

  factory Professor.fromDocument(DocumentSnapshot doc) {
    return Professor(
      imagePath: doc['imagePath'],
      name: doc['name'],
      department: doc['department'],
      email: doc['email'],
      uid: doc['uid'],
      major: doc['major'],
      words: doc['words'],
    );
  }
}
