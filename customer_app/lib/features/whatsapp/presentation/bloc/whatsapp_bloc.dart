import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/whatsapp_model.dart';
import '../../domain/usecases/open_whatsapp_chat_usecase.dart';
import '../../domain/usecases/update_whatsapp_settings_usecase.dart';
import '../../domain/repositories/whatsapp_repository.dart';

part 'whatsapp_event.dart';
part 'whatsapp_state.dart';

class WhatsAppBloc extends Bloc<WhatsAppEvent, WhatsAppState> {
  final OpenWhatsAppChatUseCase openWhatsAppChatUseCase;
  final UpdateWhatsAppSettingsUseCase updateWhatsAppSettingsUseCase;
  final WhatsAppRepository repository;

  WhatsAppBloc({
    required this.openWhatsAppChatUseCase,
    required this.updateWhatsAppSettingsUseCase,
    required this.repository,
  }) : super(WhatsAppInitial()) {
    on<OpenWhatsAppChatEvent>(_onOpenWhatsAppChat);
    on<LoadWhatsAppSettingsEvent>(_onLoadWhatsAppSettings);
    on<UpdateWhatsAppSettingsEvent>(_onUpdateWhatsAppSettings);
    on<SendWhatsAppMessageEvent>(_onSendWhatsAppMessage);
  }

  Future<void> _onOpenWhatsAppChat(
    OpenWhatsAppChatEvent event,
    Emitter<WhatsAppState> emit,
  ) async {
    try {
      await openWhatsAppChatUseCase(
        phoneNumber: event.phoneNumber,
        message: event.message,
      );
      emit(const WhatsAppChatOpened());
    } catch (e) {
      emit(WhatsAppError(e.toString()));
    }
  }

  Future<void> _onLoadWhatsAppSettings(
    LoadWhatsAppSettingsEvent event,
    Emitter<WhatsAppState> emit,
  ) async {
    emit(WhatsAppLoading());

    try {
      final settings = await repository.getSettings();
      emit(WhatsAppSettingsLoaded(settings: settings));
    } catch (e) {
      emit(WhatsAppError(e.toString()));
    }
  }

  Future<void> _onUpdateWhatsAppSettings(
    UpdateWhatsAppSettingsEvent event,
    Emitter<WhatsAppState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is! WhatsAppSettingsLoaded) return;

      emit(WhatsAppLoading());

      final updatedSettings = await updateWhatsAppSettingsUseCase(
        event.settings,
      );

      emit(WhatsAppSettingsLoaded(
        settings: updatedSettings,
        message: 'Settings updated successfully',
      ));
    } catch (e) {
      emit(WhatsAppError(e.toString()));
    }
  }

  Future<void> _onSendWhatsAppMessage(
    SendWhatsAppMessageEvent event,
    Emitter<WhatsAppState> emit,
  ) async {
    try {
      final message = await repository.sendMessage(event.request);
      emit(WhatsAppMessageSent(message: message));
    } catch (e) {
      emit(WhatsAppError(e.toString()));
    }
  }
}
