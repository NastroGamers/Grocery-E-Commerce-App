import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../products/data/models/review_model.dart';
import '../../domain/repositories/reviews_management_repository.dart';

// Events
abstract class ReviewsManagementEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitReview extends ReviewsManagementEvent {
  final CreateReviewRequest request;
  final String orderId;

  SubmitReview({required this.request, required this.orderId});

  @override
  List<Object?> get props => [request, orderId];
}

class UpdateReview extends ReviewsManagementEvent {
  final String reviewId;
  final UpdateReviewRequest request;

  UpdateReview({required this.reviewId, required this.request});

  @override
  List<Object?> get props => [reviewId, request];
}

class DeleteReview extends ReviewsManagementEvent {
  final String reviewId;

  DeleteReview(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class LoadUserReviews extends ReviewsManagementEvent {
  final int page;

  LoadUserReviews({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class MarkReviewHelpful extends ReviewsManagementEvent {
  final String reviewId;
  final bool isHelpful;

  MarkReviewHelpful({required this.reviewId, required this.isHelpful});

  @override
  List<Object?> get props => [reviewId, isHelpful];
}

// States
abstract class ReviewsManagementState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReviewsManagementInitial extends ReviewsManagementState {}

class ReviewsManagementLoading extends ReviewsManagementState {}

class ReviewSubmitted extends ReviewsManagementState {
  final ReviewModel review;

  ReviewSubmitted(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewUpdated extends ReviewsManagementState {
  final ReviewModel review;

  ReviewUpdated(this.review);

  @override
  List<Object?> get props => [review];
}

class ReviewDeleted extends ReviewsManagementState {
  final String reviewId;

  ReviewDeleted(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class UserReviewsLoaded extends ReviewsManagementState {
  final List<ReviewModel> reviews;
  final bool hasMore;

  UserReviewsLoaded({required this.reviews, this.hasMore = true});

  @override
  List<Object?> get props => [reviews, hasMore];
}

class ReviewMarkedHelpful extends ReviewsManagementState {
  final String reviewId;

  ReviewMarkedHelpful(this.reviewId);

  @override
  List<Object?> get props => [reviewId];
}

class ReviewsManagementError extends ReviewsManagementState {
  final String message;

  ReviewsManagementError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ReviewsManagementBloc extends Bloc<ReviewsManagementEvent, ReviewsManagementState> {
  final ReviewsManagementRepository repository;

  ReviewsManagementBloc({required this.repository}) : super(ReviewsManagementInitial()) {
    on<SubmitReview>(_onSubmitReview);
    on<UpdateReview>(_onUpdateReview);
    on<DeleteReview>(_onDeleteReview);
    on<LoadUserReviews>(_onLoadUserReviews);
    on<MarkReviewHelpful>(_onMarkReviewHelpful);
  }

  Future<void> _onSubmitReview(
    SubmitReview event,
    Emitter<ReviewsManagementState> emit,
  ) async {
    emit(ReviewsManagementLoading());

    final result = await repository.submitReview(event.request, event.orderId);

    result.fold(
      (failure) => emit(ReviewsManagementError(failure.message)),
      (review) => emit(ReviewSubmitted(review)),
    );
  }

  Future<void> _onUpdateReview(
    UpdateReview event,
    Emitter<ReviewsManagementState> emit,
  ) async {
    emit(ReviewsManagementLoading());

    final result = await repository.updateReview(event.reviewId, event.request);

    result.fold(
      (failure) => emit(ReviewsManagementError(failure.message)),
      (review) => emit(ReviewUpdated(review)),
    );
  }

  Future<void> _onDeleteReview(
    DeleteReview event,
    Emitter<ReviewsManagementState> emit,
  ) async {
    emit(ReviewsManagementLoading());

    final result = await repository.deleteReview(event.reviewId);

    result.fold(
      (failure) => emit(ReviewsManagementError(failure.message)),
      (_) => emit(ReviewDeleted(event.reviewId)),
    );
  }

  Future<void> _onLoadUserReviews(
    LoadUserReviews event,
    Emitter<ReviewsManagementState> emit,
  ) async {
    emit(ReviewsManagementLoading());

    final result = await repository.getUserReviews(event.page);

    result.fold(
      (failure) => emit(ReviewsManagementError(failure.message)),
      (reviews) => emit(UserReviewsLoaded(
        reviews: reviews,
        hasMore: reviews.length >= 20,
      )),
    );
  }

  Future<void> _onMarkReviewHelpful(
    MarkReviewHelpful event,
    Emitter<ReviewsManagementState> emit,
  ) async {
    final result = await repository.markReviewHelpful(event.reviewId, event.isHelpful);

    result.fold(
      (failure) => emit(ReviewsManagementError(failure.message)),
      (_) => emit(ReviewMarkedHelpful(event.reviewId)),
    );
  }
}
