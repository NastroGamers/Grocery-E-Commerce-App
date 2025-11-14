import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/recommendation_model.dart';
import '../../domain/usecases/get_personalized_recommendations_usecase.dart';
import '../../domain/usecases/track_interaction_usecase.dart';

part 'recommendations_event.dart';
part 'recommendations_state.dart';

class RecommendationsBloc extends Bloc<RecommendationsEvent, RecommendationsState> {
  final GetPersonalizedRecommendationsUseCase getPersonalizedRecommendationsUseCase;
  final TrackInteractionUseCase trackInteractionUseCase;

  RecommendationsBloc({
    required this.getPersonalizedRecommendationsUseCase,
    required this.trackInteractionUseCase,
  }) : super(RecommendationsInitial()) {
    on<LoadPersonalizedRecommendationsEvent>(_onLoadPersonalizedRecommendations);
    on<TrackProductInteractionEvent>(_onTrackProductInteraction);
  }

  Future<void> _onLoadPersonalizedRecommendations(
    LoadPersonalizedRecommendationsEvent event,
    Emitter<RecommendationsState> emit,
  ) async {
    emit(RecommendationsLoading());

    try {
      final response = await getPersonalizedRecommendationsUseCase(
        limit: event.limit,
      );

      emit(RecommendationsLoaded(
        recommendations: response.recommendations,
        algorithm: response.algorithm,
      ));
    } catch (e) {
      emit(RecommendationsError(e.toString()));
    }
  }

  Future<void> _onTrackProductInteraction(
    TrackProductInteractionEvent event,
    Emitter<RecommendationsState> emit,
  ) async {
    try {
      await trackInteractionUseCase(
        productId: event.productId,
        interactionType: event.interactionType,
        metadata: event.metadata,
      );
    } catch (e) {
      // Silent fail - don't disrupt user experience
    }
  }
}
