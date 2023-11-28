

class AnonymousUser {
  final String status_message = "I promise to take the test honestly before GOD.";
  String uid;

  AnonymousUser({required this.uid});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'status_message' : status_message
    };
  }
}