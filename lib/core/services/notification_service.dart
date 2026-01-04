import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:residential_booking_app/core/di/injection_container.dart';
import 'package:residential_booking_app/core/navigation/app_routes.dart';
import 'package:residential_booking_app/core/navigation/navigation_service.dart';
import 'package:residential_booking_app/features/auth/domain/usecases/update_fcm_token_usecase.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  static int? currentActiveConversationId;

  Future<void> initialize() async {
    if (_isInitialized) return;

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await _setupLocalNotifications();
      await _setupFCMListeners();
      await _syncToken();
    }

    _isInitialized = true;
  }

  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );

    if (Platform.isAndroid) {
      final AndroidNotificationChannel channel =
          const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _setupFCMListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (_shouldSuppressNotification(message.data)) {
        return;
      }

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              icon: '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(),
          ),
          payload: json.encode(message.data),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNavigation(message.data);
    });

    final RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNavigation(initialMessage.data);
    }
  }

  bool _shouldSuppressNotification(Map<String, dynamic> data) {
    if (currentActiveConversationId == null) return false;

    if (data.containsKey('conversation_id')) {
      final incomingId = int.tryParse(data['conversation_id'].toString());
      if (incomingId != null && incomingId == currentActiveConversationId) {
        return true;
      }
    }

    if (data.containsKey('chat_id')) {
      final incomingId = int.tryParse(data['chat_id'].toString());
      if (incomingId != null && incomingId == currentActiveConversationId) {
        return true;
      }
    }

    return false;
  }

  Future<void> _syncToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      _sendTokenToBackend(token);
    }
    _firebaseMessaging.onTokenRefresh.listen(_sendTokenToBackend);
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      final useCase = sl<UpdateFcmTokenUseCase>();
      await useCase(token);
    } catch (_) {}
  }

  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      try {
        final data = json.decode(payload);
        _handleNavigation(data);
      } catch (_) {}
    }
  }

  void _handleNavigation(Map<String, dynamic> data) {
    final nav = sl<NavigationService>();
    nav.pushNamed(AppRoutes.mainLayout, arguments: false);
  }
}
