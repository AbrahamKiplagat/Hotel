import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hotel/domain/models/hotel_model.dart';
import 'package:hotel/domain/models/room_model.dart';
import 'package:hotel/presentation/home/home_screen.dart';

import '../../providers/hotel_provider.dart';

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

  // New room form variables
  final _roomformKey = GlobalKey<FormState>();
  final type = TextEditingController();
  double roomRate = 0.0;
  bool isRoomAvailable = true;

  void addNewRoom() {
    if (_roomformKey.currentState!.validate()) {
      _roomformKey.currentState!.save();
      setState(() {
        rooms.add(Room(type: type.text, rate: roomRate, isAvailable: isRoomAvailable));
        // Clear new room form fields
        type.clear();
        roomRate = 0.0;
        isRoomAvailable = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
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
              const SizedBox(
                height: 20.0,
              ),
              Slider(
                value: rating,
                min: 0.0,
                max: 5.0,
                divisions: 10,
                label: 'Rating ($rating)',
                onChanged: (newRating) {
                  setState(() => rating = newRating);
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
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
              const SizedBox(
                height: 10.0,
              ),
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
                            const SizedBox(
                              height: 30.0,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Rate',
                              ),
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                  text: roomRate.toString()),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter room rate';
                                }
                                return null;
                              },
                              onSaved: (newValue) =>
                                  roomRate = double.parse(newValue!),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            SwitchListTile(
                              title: const Text('Available'),
                              value: isRoomAvailable,
                              onChanged: (value) =>
                                  setState(() => isRoomAvailable = value),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: addNewRoom,
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                ),
                child: const Text('Add Room'),
              ),
              const Text('Rooms:'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(rooms[index].type),
                    subtitle: Text('Rate: ${rooms[index].rate}'),
                    trailing: Text(rooms[index].isAvailable ? 'Available' : 'Not Available'),
                  );
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String name = nameController.text;
                    String location = locationController.text;
                    String imageUrl = imageUrlController.text;
                    Hotel hotel = Hotel(
                      name: name,
                      location: location,
                      imageUrl: imageUrl,
                      rating: rating,
                      rooms: rooms,
                      id: 0, // Provide a default value for id here or set it dynamically later
                    );
                    context.read<HotelProvider>().addHotel(hotel);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(title: 'Hotel Page'),
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