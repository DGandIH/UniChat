import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unichat/page/chat/chat.dart';

class Messages extends StatelessWidget {
  final String professorId;
  final String studentId;
  const Messages({Key? key, required this.professorId, required this.studentId }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .where('professorId', isEqualTo: professorId)
            .where('studentId', isEqualTo: studentId)
            .limit(1)
            // .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final docData = snapshot.data!.docs.first.data();
          final messages = docData['messages'] as List<dynamic>? ?? [];

          if (messages.isNotEmpty) {
            messages.sort((a, b) {
              var aTime = a['time'];
              var bTime = b['time'];
              if (aTime is Timestamp && bTime is Timestamp) {
                return bTime.compareTo(aTime);
              }
              return 0;
            });
          }

          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var message = messages[index];
              return Chat(
                message['text'] ?? '',
                message['uid'] == studentId,
              );
            }
          );
        },
    );
  }
}
