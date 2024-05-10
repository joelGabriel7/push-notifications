import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/domain/entities/push_messages.dart';
import 'package:push_app/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  debugPrint("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationsStatusChanges>(_notificationsStatusChanges);
    on<NotificationsRecevied>(_onPushMessageReceveid);
    // Verificar el estado de las notificaciones
    _initialStatusChecked();
    // Listener de foreground messages
    _onForegroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationsStatusChanges(
      NotificationsStatusChanges event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    _getFCMToken();
  }

  void _onPushMessageReceveid(
      NotificationsRecevied event, Emitter<NotificationsState> emit) {
    emit(
        state.copyWith(notifications: [...state.notifications, event.message]));
  }

  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;
    final token = await messaging.getToken();
    print('TOKEN: $token');
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;

    final notifications = PushMessages(
      messagID:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sendDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl,
    );

    add(NotificationsRecevied(notifications));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void _initialStatusChecked() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationsStatusChanges(settings.authorizationStatus));
  }

  void requestPermision() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    add(NotificationsStatusChanges(settings.authorizationStatus));
  }

  PushMessages? getMessageById(String pushMessageId) {
    final exist = state.notifications.any((element) => element.messagID == pushMessageId);
    if (!exist) return null;
    return state.notifications.firstWhere((element) => element.messagID == pushMessageId);
  }
}
