import 'package:flutter/material.dart';
// import 'package:hotel/main.dart';

import '../data/dummy.dart';
import '../domain/models/hotel_model.dart';
import '../domain/services/hotel_service.dart';

class HotelProvider extends ChangeNotifier {
  final HotelService _hotelService = HotelService();
//initialize an empty list of hotels
  List<Hotel> _hotels = [];
  //getter for the hotels list
  List<Hotel> get hotels => _hotels;
/*
**All the methods below are from the HotelService class
*/
  Future<void> fetchHotels() async {
    try {
      _hotels = await _hotelService.getHotels();
      notifyListeners();
    } catch (e) {
      print('Error fetching hotels: $e');
    }
  }

  Future<void> addHotel(Hotel hotel) async {
    try {
      await _hotelService.addHotel(hotel);
      _hotels.add(hotel);
      notifyListeners();
    } catch (e) {
      print('Error adding hotel: $e');
    }
  }

  Future<void> updateHotel(Hotel hotel) async {
    try {
      await _hotelService.updateHotel(hotel);
      int index = _hotels.indexWhere((h) => h.id == hotel.id);
      _hotels[index] = hotel;
      notifyListeners();
    } catch (e) {
      print('Error updating hotel: $e');
    }
  }

  Future<void> deleteHotel(Hotel hotel) async {
    try {
      await _hotelService.deleteHotel(hotel.id.toString());
      _hotels.removeWhere((h) => h.id == hotel.id);
      notifyListeners();
    } catch (e) {
      print('Error deleting hotel: $e');
    }
  }

  //call the setHotels method from the HotelService class
  Future<void> setHotels() async {
    try {
      await _hotelService.setHotels(dummyHotels);
      _hotels = dummyHotels;
      notifyListeners();
    } catch (e) {
      print('Error setting hotels: $e');
    }
  }
}
