final class UserModel {
  final String uid;
  final String email;
  final String username;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
    );
  }
}
