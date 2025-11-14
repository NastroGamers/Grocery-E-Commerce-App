part of 'whatsapp_bloc.dart';

abstract class WhatsAppEvent extends Equatable {
  const WhatsAppEvent();

  @override
  List<Object?> get props => [];
}

class OpenWhatsAppChatEvent extends WhatsAppEvent {
  final String? phoneNumber;
  final String? message;

  const OpenWhatsAppChatEvent({
    this.phoneNumber,
    this.message,
  });

  @override
  List<Object?> get props => [phoneNumber, message];
}

class LoadWhatsAppSettingsEvent extends WhatsAppEvent {}

class UpdateWhatsAppSettingsEvent extends WhatsAppEvent {
  final WhatsAppSettings settings;

  const UpdateWhatsAppSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SendWhatsAppMessageEvent extends WhatsAppEvent {
  final SendWhatsAppRequest request;

  const SendWhatsAppMessageEvent(this.request);

  @override
  List<Object?> get props => [request];
}
