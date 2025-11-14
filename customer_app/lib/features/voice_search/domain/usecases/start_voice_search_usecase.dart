import '../repositories/voice_search_repository.dart';

class StartVoiceSearchUseCase {
  final VoiceSearchRepository repository;

  StartVoiceSearchUseCase(this.repository);

  Future<Stream<String>> call({String localeId = 'en_US'}) async {
    final isAvailable = await repository.isAvailable();
    if (!isAvailable) {
      throw Exception('Speech recognition not available on this device');
    }

    final initialized = await repository.initialize();
    if (!initialized) {
      throw Exception('Failed to initialize speech recognition');
    }

    return await repository.startListening(localeId: localeId);
  }
}
