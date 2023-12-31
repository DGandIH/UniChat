  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:unichat/page/chat/message.dart';
  import 'package:unichat/page/chat/newMessage.dart';

  class ChatScreen extends StatefulWidget {
    final String curId;
    final String targetId;
    final String time;
    final String date;
    final String professorId;
    final String studentId;
    const ChatScreen({Key? key, required this.curId, required this.targetId, required this.time, required this.date, required this.professorId, required this.studentId}) : super(key: key);

    @override
    _ChatScreenState createState() => _ChatScreenState();
  }

  class _ChatScreenState extends State<ChatScreen> {
    final _authentication = FirebaseAuth.instance;
    User? loggedUser;

    @override
    void initState() {
      super.initState();
      getCurrentUser();
    }

    void getCurrentUser() {
      try {
        final user = _authentication.currentUser;
        if (user != null) {
          loggedUser = user;
          print(loggedUser!.email);
        }
      } catch(e) {
        print(e);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('커피챗 약속을 잡아보세요'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app_sharp,
                color: Colors.white,
              ),
              onPressed: (){
                _authentication.signOut();
                Navigator.pop(context);
              },

            )
          ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                  child: Messages(curId: widget.curId, targetId: widget.targetId, time: widget.time, date: widget.date, professorId: widget.professorId, studentId: widget.studentId)
              ),
              NewMessage(curId: widget.curId, targetId: widget.targetId, time: widget.time, date: widget.date, professorId: widget.professorId, studentId: widget.studentId),
            ],
          )
        )
      );
    }
  }