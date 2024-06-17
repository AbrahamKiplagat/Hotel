import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel/domain/models/user_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserModel?> createUserWithEmailAndPassword(BuildContext context, String email, String password, String displayName, String phoneNumber, File? imageFile) async {
    try {
      final hashedPassword = _hashPassword(password);
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      
      if (user != null) {
        String? imagePath;
        if (imageFile != null) {
          // Upload image file and get the path
          imagePath = await uploadImageAndGetUrl(user.uid, imageFile); // Example function to upload and get URL
        }
        
        final userModel = UserModel(
          uid: user.uid,
          email: user.email,
          displayName: displayName,
          phoneNumber: phoneNumber,
          password: hashedPassword,
          imagePath: imagePath ?? '',
        );
        
        await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

        return userModel;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
    return null;
  }

  Future<String?> uploadImageAndGetUrl(String userId, File imageFile) async {
    try {
      final storageRef = firebase_storage.FirebaseStorage.instance.ref().child('users/$userId/profile.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<UserModel?> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      final hashedPassword = _hashPassword(password);
      final userDoc = await _firestore.collection('users').where('email', isEqualTo: email).get();
      
      if (userDoc.docs.isNotEmpty) {
        final userData = userDoc.docs.first.data();
        if (userData['password'] == hashedPassword) {
          final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
          final user = userCredential.user;
          
          if (user != null) {
            return UserModel(
              uid: user.uid,
              email: user.email,
              displayName: userData['displayName'],
              phoneNumber: userData['phoneNumber'],
              password: userData['password'],
              imagePath: userData['imagePath'],
            );
          }
        } else {
          throw Exception('Invalid password');
        }
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
    return null;
  }

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
  }
}
