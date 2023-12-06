import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unichat/user/student.dart';

import '../user/professor.dart';

class SignIn {
  Future<UserCredential> signInWithGoogle() async {
    // Google 로그인 프로세스 시작
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Google 로그인 프로세스가 취소되었는지 확인
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }

    // Google 인증 세부 정보 요청
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Google 인증 세부 정보를 사용하여 Firebase 사용자 인증 정보 생성
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Firebase에 인증 정보를 사용하여 로그인
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<Student?> addUserCollection(
      String studentId, String major, String mbti, String uploadPath) async {
    // Firestore 인스턴스 가져오기
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // 사용자 문서에 대한 참조 가져오기
    CollectionReference userCollectionRef = firestore.collection('user');
    DocumentReference userDocRef = firestore
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    String? email = FirebaseAuth.instance.currentUser!.email;
    String? name = FirebaseAuth.instance.currentUser!.displayName;

    if (email != null && name != null) {
      String userEmail = email;
      String userName = name;

      QuerySnapshot querySnapshot = await userCollectionRef
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (querySnapshot.size == 0) {
        Student user = Student(
          email: userEmail,
          name: userName,
          imagePath: uploadPath,
          uid: FirebaseAuth.instance.currentUser!.uid,
          studentId: studentId,
          major: major,
          MBTI: mbti,
        );
        userDocRef.set(user.toMap());
        return user;
      }
    } else {
      QuerySnapshot querySnapshot = await userCollectionRef
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      return null;
    }
  }

  Future<Professor?> addProfessorCollection(String major, String word,
      String section, String imagePath) async {
    // Firestore 인스턴스 가져오기
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // 사용자 문서에 대한 참조 가져오기
    CollectionReference userCollectionRef = firestore.collection('professor');
    DocumentReference userDocRef = firestore
        .collection('professor')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    String? email = FirebaseAuth.instance.currentUser!.email;
    String? name = FirebaseAuth.instance.currentUser!.displayName;

    if (email != null && name != null) {
      String userEmail = email;
      String userName = name;

      QuerySnapshot querySnapshot = await userCollectionRef
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (querySnapshot.size == 0) {
        Professor user = Professor(
            email: userEmail,
            name: userName,
            uid: FirebaseAuth.instance.currentUser!.uid,
            major: major,
            department: section,
            words: word,
            imagePath: imagePath);
        userDocRef.set(user.toMap());
        return user;
      }
    } else {
      QuerySnapshot querySnapshot = await userCollectionRef
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      return null;
    }
  }

  Future<UserCredential> signInAnonymously() async {
    return await FirebaseAuth.instance.signInAnonymously();
  }

  Future<void> signOUt() async {
    await FirebaseAuth.instance.signOut();
  }


  Future<Professor> updateProfessorProfile(String documentId, String major, String words, String department, String imagePath) async {
    // Firestore 인스턴스 가져오기
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // 현재 사용자의 uid 가져오기
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    DocumentReference userDocRef = firestore.collection('professor').doc(uid);

    Map<String, dynamic> dataToUpdate = {
      'major': major,
      'department': department,
      'words': words,
      'imagePath': imagePath,
    };

    await userDocRef.update(dataToUpdate);
    DocumentSnapshot updatedDoc = await userDocRef.get();
    return Professor.fromDocument(updatedDoc);

  }
}
