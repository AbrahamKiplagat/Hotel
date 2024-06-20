// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../domain/models/hotel_model.dart'; // Ensure you have defined your models
// import '../../domain/models/room_model.dart'; // Ensure you have defined your models

// class AvailableHotelsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Available Hotels'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('hotels').snapshots(),
//         builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No hotels found.'));
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (ctx, index) {
//               DocumentSnapshot hotelDoc = snapshot.data!.docs[index];
//               Hotel hotel = Hotel.fromFirestore(hotelDoc); // Assuming Hotel.fromFirestore is a constructor/method to convert Firestore data to Hotel object

//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Card(
//                   elevation: 3,
//                   child: ListTile(
//                     title: Text(hotel.name),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Location: ${hotel.location}'),
//                         Text('Rating: ${hotel.rating}'),
//                         SizedBox(height: 10),
//                         Text(
//                           'Rooms:',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: hotel.rooms.map((room) {
//                             return ListTile(
//                               title: Text(room.type),
//                               subtitle: Text('Rate: ${room.rate}, Amount: ${room.amount}'),
//                               trailing: Text(room.isAvailable ? 'Available' : 'Not Available'),
//                             );
//                           }).toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

