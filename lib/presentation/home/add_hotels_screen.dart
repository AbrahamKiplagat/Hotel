import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/models/hotel_model.dart';
import '../../domain/models/room_model.dart';
import '../../providers/hotel_provider.dart';
import '../home/home_screen.dart';
import 'admin_drawer.dart';

class AddHotelScreen extends StatefulWidget {
  const AddHotelScreen({Key? key}) : super(key: key);

  @override
  State<AddHotelScreen> createState() => _AddHotelScreenState();
}

class _AddHotelScreenState extends State<AddHotelScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final imageUrlController = TextEditingController();
  double rating = 0.0;
  List<Room> rooms = [];
  double amount = 0.0;

  // Image picker instance
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile; // Selected image file

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  final _roomformKey = GlobalKey<FormState>();
  final type = TextEditingController();
  double roomRate = 0.0;
  double roomAmount = 0.0;
  bool isRoomAvailable = true;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _uploadImage(String hotelName) async {
    if (_imageFile == null) return;

    final Reference storageRef = FirebaseStorage.instance.ref().child('hotels').child(hotelName);
    await storageRef.putFile(File(_imageFile!.path));
    final String downloadUrl = await storageRef.getDownloadURL();

    setState(() {
      imageUrlController.text = downloadUrl;
    });
  }

  void addNewRoom() {
    if (_roomformKey.currentState!.validate()) {
      _roomformKey.currentState!.save();
      setState(() {
        rooms.add(Room(
          type: type.text,
          rate: roomRate,
          amount: roomAmount,
          isAvailable: isRoomAvailable,
        ));
        type.clear();
        roomRate = 0.0;
        roomAmount = 0.0;
        isRoomAvailable = true;
      });
    }
  }

  Future<void> _addHotelToFirestore(Hotel hotel) async {
    try {
      await FirebaseFirestore.instance.collection('hotels').add({
        'name': hotel.name,
        'location': hotel.location,
        'rating': hotel.rating,
        'imageUrl': hotel.imageUrl,
        'amount': hotel.amount,
        'rooms': hotel.rooms.map((room) => {
              'type': room.type,
              'rate': room.rate,
              'amount': room.amount,
              'isAvailable': room.isAvailable,
            }).toList(),
      });
    } catch (e) {
      print('Error adding hotel to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Hotel'),
      ),
      drawer: AdminDrawer(),
      backgroundColor: Colors.purple[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Hotel Name',
                ),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Location',
                ),
                controller: locationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Slider(
                value: rating,
                min: 0.0,
                max: 5.0,
                divisions: 10,
                label: 'Rating: $rating',
                onChanged: (newRating) {
                  setState(() => rating = newRating);
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                ),
                controller: imageUrlController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  await _pickImage();
                  if (_imageFile != null) {
                    await _uploadImage(nameController.text);
                  }
                },
                child: const Text('Pick and Upload Image'),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    amount = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Add Room'),
                      content: Form(
                        key: _roomformKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Room Type',
                              ),
                              controller: type,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter room type';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Rate',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  roomRate = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Amount',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  roomAmount = double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                            const SizedBox(height: 20.0),
                            SwitchListTile(
                              title: const Text('Available'),
                              value: isRoomAvailable,
                              onChanged: (value) {
                                setState(() {
                                  isRoomAvailable = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addNewRoom();
                            Navigator.pop(context);
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                ),
                child: const Text('Add Room'),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Rooms:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListTile(
                      title: Text('Type: ${rooms[index].type}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rate: ${rooms[index].rate}'),
                          Text('Amount: ${rooms[index].amount}'),
                          Text(rooms[index].isAvailable ? 'Available' : 'Not Available'),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String name = nameController.text;
                    String location = locationController.text;
                    String imageUrl = imageUrlController.text;
                    Hotel hotel = Hotel(
                      id: 0, // Provide a default or appropriate value for the id
                      name: name,
                      location: location,
                      rating: rating,
                      imageUrl: imageUrl,
                      rooms: rooms,
                      amount: amount,
                    );

                    await _addHotelToFirestore(hotel);

                    context.read<HotelProvider>().addHotel(hotel);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(title: 'The Hotel screen'),
                      ),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
