import 'package:flutter/material.dart';
import '../models/food_model.dart';
import '../data/foods_data.dart';

class AppProvider extends ChangeNotifier {
  List<FoodModel> _allFoods = [];
  String _searchQuery = '';

  // Untuk mengatur menu navigasi bawah nanti
  int _currentIndex = 0;

  AppProvider() {
    _loadInitialData();
  }

  // Mengambil data untuk ditampilkan
  List<FoodModel> get allFoods => _allFoods;
  String get searchQuery => _searchQuery;
  int get currentIndex => _currentIndex;

  // Logika Filter Data (Fitur Pencarian)
  List<FoodModel> get filteredFoods {
    if (_searchQuery.isEmpty) return _allFoods;

    return _allFoods
        .where(
          (food) =>
              food.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              food.daerah.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  // Memasukkan data dari foods_data.dart ke dalam sistem
  void _loadInitialData() {
    _allFoods = getAllFoods();
    notifyListeners(); // Memberitahu layar untuk update tampilan
  }

  // Fungsi saat user mengetik di kolom pencarian
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Fungsi saat user klik menu navigasi bawah
  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
