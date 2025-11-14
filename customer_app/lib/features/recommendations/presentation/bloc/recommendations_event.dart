part of 'recommendations_bloc.dart';

abstract class RecommendationsEvent extends Equatable {
  const RecommendationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPersonalizedRecommendationsEvent extends RecommendationsEvent {
  final int limit;

  const LoadPersonalizedRecommendationsEvent({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

class TrackProductInteractionEvent extends RecommendationsEvent {
  final String productId;
  final String interactionType;
  final Map<String, dynamic>? metadata;

  const TrackProductInteractionEvent({
    required this.productId,
    required this.interactionType,
    this.metadata,
  });

  @override
  List<Object?> get props => [productId, interactionType, metadata];
}
