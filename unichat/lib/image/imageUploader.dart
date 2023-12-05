

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUploader {
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();

  Future<XFile?> getData() async {
    final ImagePicker _picker = ImagePicker();
    final status = await Permission.storage.status;
    XFile? image = null;


    if(status.isDenied) {

      final result = await Permission.storage.request();

      print(result.isGranted);
      if(result.isGranted) {
        // 사용자에게 이미지를 선택하게 하는 팝업을 보여줌
        image = await _picker.pickImage(source: ImageSource.gallery);
      }
    } else if(status.isGranted) {


      // 사용자에게 이미지를 선택하게 하는 팝업을 보여줌
      image = await _picker.pickImage(source: ImageSource.gallery);
    }


    return image;
  }

  Future<String?> uploadImageToFirebase(XFile? image) async {
    if (image == null) return null;

    // 파일을 업로드하기 위한 참조 생성
    FirebaseStorage storage = FirebaseStorage.instance;
    String name = '${DateTime.now().millisecondsSinceEpoch}';
    Reference ref = storage.ref().child('uploads/' + name);

    // 파일 업로드
    UploadTask uploadTask = ref.putFile(File(image.path));
    // 업로드 완료까지 기다림
    await uploadTask.whenComplete(() => {});

    // 업로드된 파일의 URL 가져오기
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> saveImageUrlToFirestore(String url) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    print("!@#!@#!@#!@#");
    await db.collection('images').add({
      'url': url,
      'createTime': FieldValue.serverTimestamp(),
      'modifiedTime': FieldValue.serverTimestamp(),
      'userId' : FirebaseAuth.instance.currentUser!.uid,
    });

    print("success");
  }

  Future<void> updateImageUrlToFirestore(String docPath, String url) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.doc("images/" + docPath).update({'modifiedTime' : FieldValue.serverTimestamp()
      , 'url' : url});
  }

}