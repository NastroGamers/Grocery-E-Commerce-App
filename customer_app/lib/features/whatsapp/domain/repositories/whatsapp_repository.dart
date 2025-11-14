import '../../data/models/whatsapp_model.dart';

abstract class WhatsAppRepository {
  /// Open WhatsApp chat with support
  Future<void> openSupportChat();

  /// Open WhatsApp chat with specific phone number
  Future<void> openChat(String phoneNumber, {String? message});

  /// Send WhatsApp message via API (Business API)
  Future<WhatsAppMessage> sendMessage(SendWhatsAppRequest request);

  /// Get WhatsApp settings
  Future<WhatsAppSettings> getSettings();

  /// Update WhatsApp settings
  Future<WhatsAppSettings> updateSettings(WhatsAppSettings settings);

  /// Verify phone number for WhatsApp
  Future<bool> verifyPhoneNumber(String phoneNumber);

  /// Get message history
  Future<List<WhatsAppMessage>> getMessageHistory({
    int page = 1,
    int limit = 20,
  });
}
