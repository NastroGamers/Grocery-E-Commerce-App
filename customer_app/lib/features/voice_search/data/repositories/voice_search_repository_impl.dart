import '../../domain/repositories/voice_search_repository.dart';
import '../datasources/voice_search_local_datasource.dart';

class VoiceSearchRepositoryImpl implements VoiceSearchRepository {
  final VoiceSearchLocalDataSource localDataSource;

  VoiceSearchRepositoryImpl(this.localDataSource);

  @override
  Future<bool> initialize() async {
    try {
      return await localDataSource.initialize();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Stream<String>> startListening({String localeId = 'en_US'}) async {
    try {
      return await localDataSource.startListening(localeId: localeId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      await localDataSource.stopListening();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> isAvailable() async {
    try {
      return await localDataSource.isAvailable();
    } catch (e) {
      rethrow;
    }
  }

  @override
  bool isListening() {
    return localDataSource.isListening();
  }

  @override
  Future<List<String>> getAvailableLocales() async {
    try {
      return await localDataSource.getAvailableLocales();
    } catch (e) {
      rethrow;
    }
  }
}
