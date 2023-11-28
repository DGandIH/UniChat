

class GoogleUser {
  String email;
  String name;
  final String status_message = "I promise to take the test honestly before GOD.";
  String uid;

  GoogleUser({required this.email, required this.name, required this.uid});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'uid': uid,
      'status_message' : status_message
    };
  }


}