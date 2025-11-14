import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/voice_search_bloc.dart';

class VoiceSearchButton extends StatelessWidget {
  final Function(String) onSearchResult;
  final Color? color;
  final double size;

  const VoiceSearchButton({
    Key? key,
    required this.onSearchResult,
    this.color,
    this.size = 24.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceSearchBloc, VoiceSearchState>(
      listener: (context, state) {
        if (state is VoiceSearchCompleted) {
          onSearchResult(state.finalText);
        } else if (state is VoiceSearchError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isListening = state is VoiceSearchListening;

        return IconButton(
          icon: Icon(
            isListening ? Icons.mic : Icons.mic_none,
            color: isListening ? Colors.red : (color ?? Theme.of(context).primaryColor),
            size: size,
          ),
          onPressed: () {
            if (isListening) {
              context.read<VoiceSearchBloc>().add(StopVoiceSearchEvent());
            } else {
              _showVoiceSearchDialog(context);
            }
          },
        );
      },
    );
  }

  void _showVoiceSearchDialog(BuildContext context) {
    context.read<VoiceSearchBloc>().add(const StartVoiceSearchEvent());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<VoiceSearchBloc>(),
        child: const VoiceSearchDialog(),
      ),
    );
  }
}

class VoiceSearchDialog extends StatelessWidget {
  const VoiceSearchDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VoiceSearchBloc, VoiceSearchState>(
      listener: (context, state) {
        if (state is VoiceSearchCompleted || state is VoiceSearchError) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        String displayText = '';
        if (state is VoiceSearchListening) {
          displayText = state.recognizedText.isEmpty
              ? 'Listening...'
              : state.recognizedText;
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              // Animated microphone icon
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.2),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  );
                },
                onEnd: () {
                  // This will be called when animation ends
                },
              ),
              const SizedBox(height: 20),
              Text(
                displayText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Tap the button to stop',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<VoiceSearchBloc>().add(StopVoiceSearchEvent());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Stop',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
