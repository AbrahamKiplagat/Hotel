import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel/domain/models/user_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserModel?> createUserWithEmailAndPassword(BuildContext context, String email, String password, String displayName, String phoneNumber) async {
    try {
      final hashedPassword = _hashPassword(password);
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      
      if (user != null) {
        final userModel = UserModel(
          uid: user.uid,
          email: user.email,
          displayName: displayName,
          phoneNumber: phoneNumber,
          password: hashedPassword,
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
