import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hotel/domain/models/admin_models.dart'; // Update import
import 'package:hotel/domain/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Booking>> getBookings() async {
    QuerySnapshot snapshot = await _db.collection('bookings').get();
    return snapshot.docs.map((doc) => Booking.fromDocument(doc)).toList();
  }

  Future<UserModel?> getUserByEmail(String email) async {
    QuerySnapshot snapshot = await _db.collection('users').where('email', isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty) {
      return UserModel.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }
}
