import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/notification_model.dart';
import '../../domain/usecases/manage_notifications_usecase.dart';

// Events
abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {
  final int page;
  final int limit;
  LoadNotificationsEvent({this.page = 1, this.limit = 20});
  @override
  List<Object?> get props => [page, limit];
}

class MarkAsReadEvent extends NotificationEvent {
  final String notificationId;
  MarkAsReadEvent({required this.notificationId});
  @override
  List<Object?> get props => [notificationId];
}

class MarkAllAsReadEvent extends NotificationEvent {}

class DeleteNotificationEvent extends NotificationEvent {
  final String notificationId;
  DeleteNotificationEvent({required this.notificationId});
  @override
  List<Object?> get props => [notificationId];
}

class UpdateFCMTokenEvent extends NotificationEvent {
  final String fcmToken;
  final String deviceId;
  final String platform;
  UpdateFCMTokenEvent({required this.fcmToken, required this.deviceId, required this.platform});
  @override
  List<Object?> get props => [fcmToken, deviceId, platform];
}

class LoadNotificationSettingsEvent extends NotificationEvent {}

class UpdateNotificationSettingsEvent extends NotificationEvent {
  final NotificationSettings settings;
  UpdateNotificationSettingsEvent({required this.settings});
  @override
  List<Object?> get props => [settings];
}

// States
abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}
class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool hasMore;
  NotificationsLoaded({required this.notifications, required this.unreadCount, required this.hasMore});
  @override
  List<Object?> get props => [notifications, unreadCount, hasMore];
}

class NotificationMarkedAsRead extends NotificationState {}
class NotificationDeleted extends NotificationState {}
class FCMTokenUpdated extends NotificationState {}

class NotificationSettingsLoaded extends NotificationState {
  final NotificationSettings settings;
  NotificationSettingsLoaded({required this.settings});
  @override
  List<Object?> get props => [settings];
}

class NotificationSettingsUpdated extends NotificationState {}
class NotificationError extends NotificationState {
  final String message;
  NotificationError({required this.message});
  @override
  List<Object?> get props => [message];
}

// Bloc
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final ManageNotificationsUseCase manageNotificationsUseCase;

  NotificationBloc({required this.manageNotificationsUseCase}) : super(NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
    on<DeleteNotificationEvent>(_onDeleteNotification);
    on<UpdateFCMTokenEvent>(_onUpdateFCMToken);
    on<LoadNotificationSettingsEvent>(_onLoadNotificationSettings);
    on<UpdateNotificationSettingsEvent>(_onUpdateNotificationSettings);
  }

  Future<void> _onLoadNotifications(LoadNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final response = await manageNotificationsUseCase.getNotifications(page: event.page, limit: event.limit);
      emit(NotificationsLoaded(notifications: response.notifications, unreadCount: response.unreadCount, hasMore: response.hasMore));
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onMarkAsRead(MarkAsReadEvent event, Emitter<NotificationState> emit) async {
    try {
      await manageNotificationsUseCase.markAsRead(event.notificationId);
      emit(NotificationMarkedAsRead());
      add(LoadNotificationsEvent());
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onMarkAllAsRead(MarkAllAsReadEvent event, Emitter<NotificationState> emit) async {
    try {
      await manageNotificationsUseCase.markAllAsRead();
      add(LoadNotificationsEvent());
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onDeleteNotification(DeleteNotificationEvent event, Emitter<NotificationState> emit) async {
    try {
      await manageNotificationsUseCase.deleteNotification(event.notificationId);
      emit(NotificationDeleted());
      add(LoadNotificationsEvent());
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onUpdateFCMToken(UpdateFCMTokenEvent event, Emitter<NotificationState> emit) async {
    try {
      await manageNotificationsUseCase.updateFCMToken(fcmToken: event.fcmToken, deviceId: event.deviceId, platform: event.platform);
      emit(FCMTokenUpdated());
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onLoadNotificationSettings(LoadNotificationSettingsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final settings = await manageNotificationsUseCase.getNotificationSettings();
      emit(NotificationSettingsLoaded(settings: settings));
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onUpdateNotificationSettings(UpdateNotificationSettingsEvent event, Emitter<NotificationState> emit) async {
    try {
      await manageNotificationsUseCase.updateNotificationSettings(event.settings);
      emit(NotificationSettingsUpdated());
      add(LoadNotificationSettingsEvent());
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }
}
