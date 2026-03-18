import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import '../models/food_item.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz_data.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _isInitialized = true;
  }

  void _onNotificationTap(NotificationResponse response) {}

  Future<void> scheduleMissingItemsNotification(List<FoodItem> itemsToBuy) async {
    if (itemsToBuy.isEmpty) return;

    await cancelAllNotifications();

    final names = itemsToBuy.map((e) => e.name).take(3).join(', ');
    final more = itemsToBuy.length > 3 ? ' y ${itemsToBuy.length - 3} más' : '';

    await _showNotification(
      id: 1,
      title: '🛒 Lista de Compras',
      body: 'Te faltan: $names$more',
      importance: Importance.high,
    );
  }

  Future<void> scheduleExpiryReminder(List<FoodItem> expiringItems) async {
    if (expiringItems.isEmpty) return;

    final names = expiringItems.map((e) => e.name).take(3).join(', ');
    final more = expiringItems.length > 3 ? ' y ${expiringItems.length - 3} más' : '';

    await _showNotification(
      id: 2,
      title: '⚠️ Productos por caducar',
      body: '$names$more están próximos a caducar',
      importance: Importance.high,
    );
  }

  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    Importance importance = Importance.defaultImportance,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'gestor_alimentos_channel',
      'Gestor de Alimentos',
      channelDescription: 'Notificaciones del gestor de alimentos',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(id, title, body, details);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
