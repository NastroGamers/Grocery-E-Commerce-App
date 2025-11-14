part of 'voice_search_bloc.dart';

abstract class VoiceSearchState extends Equatable {
  const VoiceSearchState();

  @override
  List<Object?> get props => [];
}

class VoiceSearchInitial extends VoiceSearchState {}

class VoiceSearchListening extends VoiceSearchState {
  final String recognizedText;

  const VoiceSearchListening({required this.recognizedText});

  @override
  List<Object?> get props => [recognizedText];
}

class VoiceSearchCompleted extends VoiceSearchState {
  final String finalText;

  const VoiceSearchCompleted(this.finalText);

  @override
  List<Object?> get props => [finalText];
}

class VoiceSearchError extends VoiceSearchState {
  final String message;

  const VoiceSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
