import 'package:flutter/material.dart';
import '../models/destination.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Destination> _favorites = [];

  List<Destination> get favorites => _favorites;

  bool isFavorite(Destination destination) {
    return _favorites.any((d) => d.name == destination.name);
  }

  void toggleFavorite(Destination destination) {
    if (isFavorite(destination)) {
      _favorites.removeWhere((d) => d.name == destination.name);
    } else {
      _favorites.add(destination);
    }
    notifyListeners();
  }
}