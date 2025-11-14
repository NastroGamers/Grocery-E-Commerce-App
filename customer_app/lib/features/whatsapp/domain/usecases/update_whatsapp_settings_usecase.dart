import '../repositories/whatsapp_repository.dart';
import '../../data/models/whatsapp_model.dart';

class UpdateWhatsAppSettingsUseCase {
  final WhatsAppRepository repository;

  UpdateWhatsAppSettingsUseCase(this.repository);

  Future<WhatsAppSettings> call(WhatsAppSettings settings) async {
    return await repository.updateSettings(settings);
  }
}
