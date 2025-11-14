/// Repository interface for voice search functionality
abstract class VoiceSearchRepository {
  /// Initialize speech recognition
  Future<bool> initialize();

  /// Start listening to user's voice
  Future<Stream<String>> startListening({
    String localeId = 'en_US',
  });

  /// Stop listening
  Future<void> stopListening();

  /// Check if speech recognition is available
  Future<bool> isAvailable();

  /// Check if currently listening
  bool isListening();

  /// Get list of available locales
  Future<List<String>> getAvailableLocales();
}
