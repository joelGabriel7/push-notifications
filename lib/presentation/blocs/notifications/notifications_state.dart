part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  
  // TODO: crear mi modelo de notificaciones
  final List<PushMessages> notifications;

  final AuthorizationStatus status;
  const NotificationsState({
  this.status = AuthorizationStatus.notDetermined, 
  this.notifications = const []
  
});

  NotificationsState copyWith({
      AuthorizationStatus? status,
      List<PushMessages>? notifications,
  }) => NotificationsState(
    status: status ?? this.status,
    notifications: notifications ?? this.notifications,
  );


  @override
  List<Object> get props => [status,notifications];
}
