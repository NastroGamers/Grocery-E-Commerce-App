part of 'whatsapp_bloc.dart';

abstract class WhatsAppState extends Equatable {
  const WhatsAppState();

  @override
  List<Object?> get props => [];
}

class WhatsAppInitial extends WhatsAppState {}

class WhatsAppLoading extends WhatsAppState {}

class WhatsAppChatOpened extends WhatsAppState {
  const WhatsAppChatOpened();
}

class WhatsAppSettingsLoaded extends WhatsAppState {
  final WhatsAppSettings settings;
  final String? message;

  const WhatsAppSettingsLoaded({
    required this.settings,
    this.message,
  });

  @override
  List<Object?> get props => [settings, message];
}

class WhatsAppMessageSent extends WhatsAppState {
  final WhatsAppMessage message;

  const WhatsAppMessageSent({required this.message});

  @override
  List<Object?> get props => [message];
}

class WhatsAppError extends WhatsAppState {
  final String message;

  const WhatsAppError(this.message);

  @override
  List<Object?> get props => [message];
}
