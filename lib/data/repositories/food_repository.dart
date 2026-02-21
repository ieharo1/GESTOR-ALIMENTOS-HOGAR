import '../models/food_item.dart';
import '../database/database_service.dart';

class FoodRepository {
  final DatabaseService _databaseService;

  FoodRepository(this._databaseService);

  Future<void> addFoodItem(FoodItem item) async {
    await _databaseService.addFoodItem(item);
  }

  Future<void> updateFoodItem(FoodItem item) async {
    await _databaseService.updateFoodItem(item);
  }

  Future<void> deleteFoodItem(String id) async {
    await _databaseService.deleteFoodItem(id);
  }

  List<FoodItem> getAllFoodItems() {
    return _databaseService.getAllFoodItems();
  }

  List<FoodItem> getFoodItemsByCategory(String category) {
    return _databaseService.getFoodItemsByCategory(category);
  }

  List<FoodItem> searchFoodItems(String category, String query) {
    return _databaseService.searchFoodItems(category, query);
  }

  FoodItem? getFoodItemById(String id) {
    return _databaseService.getFoodItemById(id);
  }
}
