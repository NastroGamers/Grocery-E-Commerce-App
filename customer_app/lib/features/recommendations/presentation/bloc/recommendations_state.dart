part of 'recommendations_bloc.dart';

abstract class RecommendationsState extends Equatable {
  const RecommendationsState();

  @override
  List<Object?> get props => [];
}

class RecommendationsInitial extends RecommendationsState {}

class RecommendationsLoading extends RecommendationsState {}

class RecommendationsLoaded extends RecommendationsState {
  final List<RecommendationModel> recommendations;
  final String algorithm;

  const RecommendationsLoaded({
    required this.recommendations,
    required this.algorithm,
  });

  @override
  List<Object?> get props => [recommendations, algorithm];
}

class RecommendationsError extends RecommendationsState {
  final String message;

  const RecommendationsError(this.message);

  @override
  List<Object?> get props => [message];
}
