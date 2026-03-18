import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/constants/app_constants.dart';
import 'data/database/database_service.dart';
import 'data/models/food_item.dart';
import 'data/repositories/food_repository.dart';
import 'data/services/notification_service.dart';
import 'presentation/providers/food_provider.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  await initializeDateFormatting('es_ES', null);
  await Hive.initFlutter();
  final databaseService = await DatabaseService.getInstance();
  final foodRepository = FoodRepository(databaseService);
  
  await NotificationService().initialize();
  await _resetAndAddSampleData(foodRepository);
  await _checkAndNotify(foodRepository);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FoodProvider(foodRepository),
        ),
      ],
      child: const GestorAlimentosApp(),
    ),
  );
}

Future<void> _resetAndAddSampleData(FoodRepository repository) async {
  final now = DateTime.now();
  
  // Limpiar TODOS los datos existentes
  final existing = repository.getAllFoodItems();
  for (var item in existing) {
    await repository.deleteFoodItem(item.id);
  }
  
  // Agregar datos frescos - Refrigeración
  await repository.addFoodItem(FoodItem(id: 'r1', category: 'Refrigeración', name: 'Leche', quantity: 2, entryDate: now, expirationDate: now.add(const Duration(days: 5))));
  await repository.addFoodItem(FoodItem(id: 'r2', category: 'Refrigeración', type: 'Refrigerado', name: 'Queso', quantity: 1, entryDate: now.subtract(const Duration(days: 3)), expirationDate: now.add(const Duration(days: 2))));
  await repository.addFoodItem(FoodItem(id: 'r3', category: 'Refrigeración', name: 'Huevos', quantity: 0, entryDate: now.subtract(const Duration(days: 5)), expirationDate: now.add(const Duration(days: 9))));
  await repository.addFoodItem(FoodItem(id: 'r4', category: 'Refrigeración', type: 'Congelado', name: 'Pollo', quantity: 3, entryDate: now.subtract(const Duration(days: 2)), expirationDate: now.add(const Duration(days: 1))));
  
  // Agregar datos frescos - Alacena
  await repository.addFoodItem(FoodItem(id: 'a1', category: 'Alacena', name: 'Arroz', quantity: 5, entryDate: now.subtract(const Duration(days: 10)), expirationDate: now.add(const Duration(days: 180))));
  await repository.addFoodItem(FoodItem(id: 'a2', category: 'Alacena', name: 'Fideos', quantity: 0, entryDate: now.subtract(const Duration(days: 30)), expirationDate: now.add(const Duration(days: 90))));
  await repository.addFoodItem(FoodItem(id: 'a3', category: 'Alacena', name: 'Salsa de Tomate', quantity: 0, entryDate: now.subtract(const Duration(days: 60)), expirationDate: now.add(const Duration(days: 30))));
  await repository.addFoodItem(FoodItem(id: 'a4', category: 'Alacena', name: 'Atún', quantity: 4, entryDate: now.subtract(const Duration(days: 15)), expirationDate: now.add(const Duration(days: 2))));
}

Future<void> _checkAndNotify(FoodRepository repository) async {
  final allItems = repository.getAllFoodItems();
  final now = DateTime.now();
  
  final itemsToBuy = allItems.where((item) => item.quantity == 0).toList();
  final expiringItems = allItems.where((item) {
    if (item.quantity == 0) return false;
    final daysUntilExpiry = item.expirationDate.difference(now).inDays;
    return daysUntilExpiry <= 3 && daysUntilExpiry >= 0;
  }).toList();
  
  if (itemsToBuy.isNotEmpty) {
    await NotificationService().scheduleMissingItemsNotification(itemsToBuy);
  }
  
  if (expiringItems.isNotEmpty) {
    await NotificationService().scheduleExpiryReminder(expiringItems);
  }
}

class GestorAlimentosApp extends StatelessWidget {
  const GestorAlimentosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      shortcuts: {},
      actions: {},
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'US'),
      ],
      locale: const Locale('es', 'ES'),
      home: const HomeScreen(),
    );
  }

  ThemeData _buildLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1565C0),
      brightness: Brightness.light,
      secondary: const Color(0xFF00897B),
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: colorScheme.surface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1565C0),
      brightness: Brightness.dark,
      secondary: const Color(0xFF00897B),
    );
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: colorScheme.surface,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
