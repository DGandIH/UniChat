
class Student {
  String email;
  String name;
  String uid;
  int studentId;
  String major;
  String MBTI;

  Student({required this.email, required this.name, required this.uid, required this.studentId, required this.major, required this.MBTI});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'uid': uid,
      'studentId' : studentId,
      'major' : major,
      'MBTI' : MBTI
    };
  }


}