import 'package:hive_flutter/hive_flutter.dart';
import '../models/food_item.dart';
import '../../core/constants/app_constants.dart';

class DatabaseService {
  static DatabaseService? _instance;
  late Box<FoodItem> _foodBox;

  DatabaseService._();

  static Future<DatabaseService> getInstance() async {
    if (_instance == null) {
      _instance = DatabaseService._();
      await _instance!._init();
    }
    return _instance!;
  }

  Future<void> _init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(FoodItemAdapter());
    _foodBox = await Hive.openBox<FoodItem>(AppConstants.foodBoxName);
  }

  Box<FoodItem> get foodBox => _foodBox;

  Future<void> addFoodItem(FoodItem item) async {
    await _foodBox.put(item.id, item);
  }

  Future<void> updateFoodItem(FoodItem item) async {
    await _foodBox.put(item.id, item);
  }

  Future<void> deleteFoodItem(String id) async {
    await _foodBox.delete(id);
  }

  List<FoodItem> getAllFoodItems() {
    return _foodBox.values.toList();
  }

  List<FoodItem> getFoodItemsByCategory(String category) {
    return _foodBox.values
        .where((item) => item.category == category)
        .toList();
  }

  List<FoodItem> searchFoodItems(String category, String query) {
    return _foodBox.values
        .where((item) =>
            item.category == category &&
            item.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  FoodItem? getFoodItemById(String id) {
    return _foodBox.get(id);
  }

  Future<void> close() async {
    await _foodBox.close();
  }
}
