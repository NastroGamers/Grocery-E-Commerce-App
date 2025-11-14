import '../repositories/voice_search_repository.dart';

class StopVoiceSearchUseCase {
  final VoiceSearchRepository repository;

  StopVoiceSearchUseCase(this.repository);

  Future<void> call() async {
    await repository.stopListening();
  }
}
