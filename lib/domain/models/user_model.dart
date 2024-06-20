class UserModel {
  String uid;
  String? email;
  String? displayName;
  String? imagePath;
  String? phoneNumber;
  String? password;
  String? fullName; // Add fullName field

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.imagePath,
    this.phoneNumber,
    this.password,
    this.fullName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'email': email,
      'displayName': displayName,
      'imagePath': imagePath,
      'phoneNumber': phoneNumber,
      'password': password,
      'fullName': fullName, // Include fullName in JSON serialization
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      imagePath: json['imagePath'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      fullName: json['fullName'], // Deserialize fullName from JSON
    );
  }
}
