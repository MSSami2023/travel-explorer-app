import 'package:flutter/material.dart';
import '../models/destination.dart';

class Booking {
  final Destination destination;
  final DateTime date;
  final int guests;
  final String fullName;
  final String email;
  final String phone;
  final String status;
  final String id;

  Booking({
    required this.destination,
    required this.date,
    required this.guests,
    required this.fullName,
    required this.email,
    required this.phone,
    this.status = 'Confirmed',
    String? id,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}

class BookingProvider extends ChangeNotifier {
  final List<Booking> _bookings = [];

  List<Booking> get bookings => List.unmodifiable(_bookings);
  int get count => _bookings.length;
  double get totalSpent =>
      _bookings.fold(0, (sum, b) => sum + b.destination.price * b.guests);

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void cancelBooking(String id) {
    _bookings.removeWhere((b) => b.id == id);
    notifyListeners();
  }
}