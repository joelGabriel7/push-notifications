part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];
}

class NotificationsStatusChanges extends NotificationsEvent {
  final AuthorizationStatus status;

  const NotificationsStatusChanges(this.status);
}



class NotificationsRecevied extends NotificationsEvent {
  final PushMessages message;

  const NotificationsRecevied(this.message);

  
}