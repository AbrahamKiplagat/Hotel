enum UserRole { admin, user }

class UserModel {
  String uid;
  String? email; // Make email nullable
  String? displayName; // Make displayName nullable
  String? imagePath;
  String? phoneNumber; // Make phoneNumber nullable
  String? password; // Make password nullable

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.imagePath,
    this.phoneNumber,
    this.password,
  });

  // Serialize data to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'email': email,
      'displayName': displayName,
      'imagePath': imagePath,
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }

  // Deserialize JSON data to object received from cloud firestore
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      imagePath: json['imagePath'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
    );
  }
}
