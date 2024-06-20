import 'package:flutter/material.dart';
import '../domain/models/hotel_model.dart';
import '../domain/services/hotel_service.dart';

class HotelProvider extends ChangeNotifier {
  final HotelService _hotelService = HotelService();
  List<Hotel> _hotels = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  List<Hotel> get hotels => _hotels;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  Future<void> fetchHotels() async {
    try {
      _isLoading = true;
      notifyListeners();

      _hotels = await _hotelService.getHotels();

      _isLoading = false;
      _hasError = false;
      _errorMessage = '';

      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Error fetching hotels: $e';
      print(_errorMessage);
      notifyListeners();
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

  Future<void> setHotels(List<Hotel> hotels) async {
    try {
      await _hotelService.setHotels(hotels);
      _hotels = hotels; // Update local list with the new hotels
      notifyListeners();
    } catch (e) {
      print('Error setting hotels: $e');
    }
  }
}

