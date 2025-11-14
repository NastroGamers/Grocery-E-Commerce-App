part of 'voice_search_bloc.dart';

abstract class VoiceSearchEvent extends Equatable {
  const VoiceSearchEvent();

  @override
  List<Object?> get props => [];
}

class StartVoiceSearchEvent extends VoiceSearchEvent {
  final String localeId;

  const StartVoiceSearchEvent({this.localeId = 'en_US'});

  @override
  List<Object?> get props => [localeId];
}

class StopVoiceSearchEvent extends VoiceSearchEvent {}

class VoiceResultReceivedEvent extends VoiceSearchEvent {
  final String text;

  const VoiceResultReceivedEvent(this.text);

  @override
  List<Object?> get props => [text];
}
