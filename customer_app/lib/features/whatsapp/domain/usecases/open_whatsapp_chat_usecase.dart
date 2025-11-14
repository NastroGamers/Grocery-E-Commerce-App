import '../repositories/whatsapp_repository.dart';

class OpenWhatsAppChatUseCase {
  final WhatsAppRepository repository;

  OpenWhatsAppChatUseCase(this.repository);

  Future<void> call({String? phoneNumber, String? message}) async {
    if (phoneNumber != null) {
      return await repository.openChat(phoneNumber, message: message);
    } else {
      return await repository.openSupportChat();
    }
  }
}
