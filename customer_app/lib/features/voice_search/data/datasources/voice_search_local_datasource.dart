import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;

abstract class VoiceSearchLocalDataSource {
  Future<bool> initialize();
  Future<Stream<String>> startListening({String localeId});
  Future<void> stopListening();
  Future<bool> isAvailable();
  bool isListening();
  Future<List<String>> getAvailableLocales();
}

class VoiceSearchLocalDataSourceImpl implements VoiceSearchLocalDataSource {
  final stt.SpeechToText _speech;
  final StreamController<String> _textController = StreamController<String>.broadcast();
  bool _isListening = false;

  VoiceSearchLocalDataSourceImpl(this._speech);

  @override
  Future<bool> initialize() async {
    try {
      return await _speech.initialize(
        onError: (error) {
          _textController.addError(error.errorMsg);
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            _isListening = false;
          }
        },
      );
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Stream<String>> startListening({String localeId = 'en_US'}) async {
    if (!_speech.isAvailable) {
      throw Exception('Speech recognition not available');
    }

    _isListening = true;

    await _speech.listen(
      onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          _textController.add(result.recognizedWords);
        }
      },
      localeId: localeId,
      listenMode: stt.ListenMode.confirmation,
      cancelOnError: false,
      partialResults: true,
      onSoundLevelChange: (level) {
        // Could be used for UI feedback
      },
    );

    return _textController.stream;
  }

  @override
  Future<void> stopListening() async {
    _isListening = false;
    await _speech.stop();
  }

  @override
  Future<bool> isAvailable() async {
    return _speech.isAvailable;
  }

  @override
  bool isListening() {
    return _isListening && _speech.isListening;
  }

  @override
  Future<List<String>> getAvailableLocales() async {
    final locales = await _speech.locales();
    return locales.map((locale) => locale.localeId).toList();
  }

  void dispose() {
    _textController.close();
  }
}
