import 'package:flutter/material.dart';
import 'package:hotel/domain/services/booking_service.dart';
import '../domain/models/booking_models.dart';

class BookingsProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<Booking> _bookings = [];
  bool _isLoading = true;
  String? _error;

  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void fetchBookings() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _bookings = await _bookingService.fetchBookingsForUser();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
}
