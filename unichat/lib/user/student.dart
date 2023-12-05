
import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String email;
  String name;
  String uid;
  String studentId;
  String major;
  String MBTI;
  String imagePath;

  Student({required this.email, required this.name, required this.uid, required this.studentId, required this.major, required this.MBTI, required this.imagePath});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'uid': uid,
      'studentId' : studentId,
      'major' : major,
      'MBTI' : MBTI,
      'imagePath' : imagePath
    };
  }
  factory Student.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Student(
      imagePath: data['imagePath'] as String,
      email: data['email'] as String,
      name: data['name'] as String,
      uid: doc.id,
      studentId: data['studentId'] as String,
      major: data['major'] as String,
      MBTI: data['MBTI'] as String,
    );
  }


}