class AppConstants {
  static const String appName = 'Gestor de Alimentos Hogar';
  
  // Categories
  static const String categoryRefrigeracion = 'Refrigeracion';
  static const String categoryAlacena = 'Alacena';
  
  // Food Types
  static const String typeRefrigerado = 'Refrigerado';
  static const String typeCongelado = 'Congelado';
  
  // Hive Box
  static const String foodBoxName = 'food_items';
  
  // Validation Messages
  static const String validationNameRequired = 'El nombre es requerido';
  static const String validationQuantityRequired = 'La cantidad es requerida';
  static const String validationQuantityPositive = 'La cantidad debe ser mayor a cero';
  static const String validationTypeRequired = 'El tipo es requerido';
  
  // Success Messages
  static const String successItemAdded = 'Artículo agregado correctamente';
  static const String successItemDeleted = 'Artículo eliminado correctamente';
  static const String successItemUpdated = 'Artículo actualizado correctamente';
  
  // Error Messages
  static const String errorGeneric = 'Ocurrió un error. Intente de nuevo.';
  static const String errorDatabase = 'Error al acceder a la base de datos';
}
