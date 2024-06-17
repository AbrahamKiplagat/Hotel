import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel/domain/models/user_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoggedIn = false;
  UserModel? _user;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> createUserWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
    String displayName,
    String phoneNumber,
    File? imageFile,
  ) async {
    try {
      final hashedPassword = _hashPassword(password);
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      
      if (user != null) {
        String? imagePath;
        if (imageFile != null) {
          imagePath = await _uploadImageAndGetUrl(user.uid, imageFile);
        }
        
        final userModel = UserModel(
          uid: user.uid,
          email: user.email,
          displayName: displayName,
          phoneNumber: phoneNumber,
          password: hashedPassword,
          imagePath: imagePath ?? '', // Provide a default value if imagePath is null
        );
        
        await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

        _isLoggedIn = true;
        _user = userModel;
        _errorMessage = null;

        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;

      if (user != null) {
        final userData = await _firestore.collection('users').doc(user.uid).get();
        final userModel = UserModel.fromJson(userData.data()!);

        _isLoggedIn = true;
        _user = userModel;
        _errorMessage = null;

        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();
      _isLoggedIn = false;
      _user = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<String?> _uploadImageAndGetUrl(String userId, File imageFile) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${userId}_${imageFile.path.split('/').last}';
      Reference ref = storage.ref().child('users').child(userId).child(fileName);
      UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() => null);
      String url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
