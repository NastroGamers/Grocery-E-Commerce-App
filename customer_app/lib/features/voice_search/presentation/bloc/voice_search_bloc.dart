import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/start_voice_search_usecase.dart';
import '../../domain/usecases/stop_voice_search_usecase.dart';

part 'voice_search_event.dart';
part 'voice_search_state.dart';

class VoiceSearchBloc extends Bloc<VoiceSearchEvent, VoiceSearchState> {
  final StartVoiceSearchUseCase startVoiceSearchUseCase;
  final StopVoiceSearchUseCase stopVoiceSearchUseCase;

  StreamSubscription<String>? _voiceSubscription;

  VoiceSearchBloc({
    required this.startVoiceSearchUseCase,
    required this.stopVoiceSearchUseCase,
  }) : super(VoiceSearchInitial()) {
    on<StartVoiceSearchEvent>(_onStartVoiceSearch);
    on<StopVoiceSearchEvent>(_onStopVoiceSearch);
    on<VoiceResultReceivedEvent>(_onVoiceResultReceived);
  }

  Future<void> _onStartVoiceSearch(
    StartVoiceSearchEvent event,
    Emitter<VoiceSearchState> emit,
  ) async {
    try {
      emit(VoiceSearchListening(recognizedText: ''));

      final stream = await startVoiceSearchUseCase(localeId: event.localeId);

      await _voiceSubscription?.cancel();
      _voiceSubscription = stream.listen(
        (text) {
          add(VoiceResultReceivedEvent(text));
        },
        onError: (error) {
          add(StopVoiceSearchEvent());
          emit(VoiceSearchError(error.toString()));
        },
      );
    } catch (e) {
      emit(VoiceSearchError(e.toString()));
    }
  }

  Future<void> _onStopVoiceSearch(
    StopVoiceSearchEvent event,
    Emitter<VoiceSearchState> emit,
  ) async {
    try {
      await _voiceSubscription?.cancel();
      await stopVoiceSearchUseCase();

      final currentState = state;
      if (currentState is VoiceSearchListening) {
        if (currentState.recognizedText.isNotEmpty) {
          emit(VoiceSearchCompleted(currentState.recognizedText));
        } else {
          emit(VoiceSearchInitial());
        }
      } else {
        emit(VoiceSearchInitial());
      }
    } catch (e) {
      emit(VoiceSearchError(e.toString()));
    }
  }

  void _onVoiceResultReceived(
    VoiceResultReceivedEvent event,
    Emitter<VoiceSearchState> emit,
  ) {
    emit(VoiceSearchListening(recognizedText: event.text));
  }

  @override
  Future<void> close() {
    _voiceSubscription?.cancel();
    return super.close();
  }
}
