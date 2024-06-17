import 'package:flutter/material.dart';

class UserModel {
  String uid;
  String? email;
  String? displayName;
  String imagePath; // Ensure imagePath is always a non-nullable string
  String? phoneNumber;
  String? password;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.imagePath = '', // Initialize imagePath with an empty string
    this.phoneNumber,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'email': email,
      'displayName': displayName,
      'imagePath': imagePath, // Ensure imagePath is always included in the JSON
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      imagePath: json['imagePath'] ?? '', // Convert null to empty string
      phoneNumber: json['phoneNumber'],
      password: json['password'],
    );
  }
}
