enum UserRole { admin, user }

class UserModel {
  String uid;
  String email;
  String displayName;
  String? imagePath;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.imagePath,
  });

  // Serialize data to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'email': email,
      'displayName': displayName,
      'imagePath': imagePath,
    };
  }

  // Deserialize JSON data to object received from cloud firestore
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      imagePath: json['imagePath'],
    );
  }
}
