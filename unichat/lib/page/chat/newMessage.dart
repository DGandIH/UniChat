import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  final String curId;
  final String targetId;
  final String time;
  final String date;
  final String professorId;
  final String studentId;
  const NewMessage({Key? key, required this.curId, required this.targetId, required this.time, required this.date, required this.professorId, required this.studentId}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();


  var _userEnterMessage = '';
  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    _controller.clear();
    // final user = FirebaseAuth.instance.currentUser;

    final String curId = widget.curId;
    final String targetId = widget.targetId;
    final String time = widget.time;
    final String date = widget.date;
    final String professorId = widget.professorId;
    final String studentId = widget.studentId;

    var chatRef = FirebaseFirestore.instance.collection('chat');

    var querySnapshot = await chatRef
        .where('professorId', isEqualTo: professorId)
        .where('studentId', isEqualTo: studentId)
        .where('time', isEqualTo: time)
        .where('date', isEqualTo: date)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      // 일치하는 문서가 없으면 새로운 문서를 생성합니다.
      await chatRef.add({
        'professorId': targetId,
        'studentId': curId,
        'time': time,
        'date': date,
        'messages': [
          {
            'text': _userEnterMessage,
            'time': Timestamp.now(),
            'uid': curId,
          },
        ],
      });
    } else {
      // 일치하는 문서가 있으면 해당 문서에 메시지를 추가합니다.
      var docRef = querySnapshot.docs.first.reference;
      await chatRef.doc(docRef.id).update({
        'messages': FieldValue.arrayUnion([
          {
            'text': _userEnterMessage,
            'time': Timestamp.now(),
            'uid': curId,
          },
        ]),
      });
    }
    // FirebaseFirestore.instance.collection('chat').add({
    //   'text' : _userEnterMessage,
    //   // 'uid' : user!.uid,
    //   'uid' : widget.studentId,
    //   'time' : Timestamp.now(),
    //   // 'userName': userData.data()!['userName'],
    //   'userName': "InHyeok",
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                });
              }
            ),
          ),
          IconButton(
            onPressed: _userEnterMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(Icons.send),
            color: Colors.blue,
          )
        ],
      )
    );
  }
}
