import 'package:flutter/material.dart';
import '../models/destination.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Destination> _favorites = [];

  List<Destination> get favorites => List.unmodifiable(_favorites);
  int get count => _favorites.length;

  bool isFavorite(String id) => _favorites.any((d) => d.id == id);

  void toggleFavorite(Destination destination) {
    if (isFavorite(destination.id)) {
      _favorites.removeWhere((d) => d.id == destination.id);
    } else {
      _favorites.add(destination);
    }
    notifyListeners();
  }

  void clearAll() {
    _favorites.clear();
    notifyListeners();
  }
}