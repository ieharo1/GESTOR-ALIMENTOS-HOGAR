import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/food_item.dart';
import '../../data/repositories/food_repository.dart';
import '../../core/constants/app_constants.dart';

class FoodProvider with ChangeNotifier {
  final FoodRepository _repository;
  final Uuid _uuid = const Uuid();

  List<FoodItem> _items = [];
  List<FoodItem> _filteredItems = [];
  String _searchQuery = '';
  String _currentCategory = '';
  bool _isLoading = false;
  String? _errorMessage;

  FoodProvider(this._repository);

  List<FoodItem> get items => _filteredItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  void loadItemsByCategory(String category) {
    _currentCategory = category;
    _searchQuery = '';
    _isLoading = true;
    notifyListeners();

    try {
      _items = _repository.getFoodItemsByCategory(category);
      _filteredItems = List.from(_items);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = AppConstants.errorDatabase;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchItems(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredItems = List.from(_items);
    } else {
      _filteredItems = _items
          .where((item) =>
              item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Future<bool> addItem({
    required String name,
    required int quantity,
    required DateTime entryDate,
    String? type,
  }) async {
    try {
      final item = FoodItem(
        id: _uuid.v4(),
        category: _currentCategory,
        type: type,
        name: name,
        quantity: quantity,
        entryDate: entryDate,
      );

      await _repository.addFoodItem(item);
      loadItemsByCategory(_currentCategory);
      return true;
    } catch (e) {
      _errorMessage = AppConstants.errorGeneric;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateItem(FoodItem item) async {
    try {
      await _repository.updateFoodItem(item);
      loadItemsByCategory(_currentCategory);
      return true;
    } catch (e) {
      _errorMessage = AppConstants.errorGeneric;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteItem(String id) async {
    try {
      await _repository.deleteFoodItem(id);
      loadItemsByCategory(_currentCategory);
      return true;
    } catch (e) {
      _errorMessage = AppConstants.errorGeneric;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
