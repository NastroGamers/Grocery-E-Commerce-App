import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/product_model.dart';
import '../../data/models/review_model.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../../domain/usecases/get_product_reviews_usecase.dart';
import '../../domain/usecases/create_review_usecase.dart';
import '../../../products/domain/repositories/products_repository.dart';

// Events
abstract class ProductDetailsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProductDetailsEvent extends ProductDetailsEvent {
  final String productId;

  LoadProductDetailsEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class LoadProductReviewsEvent extends ProductDetailsEvent {
  final String productId;
  final int page;

  LoadProductReviewsEvent({
    required this.productId,
    this.page = 1,
  });

  @override
  List<Object?> get props => [productId, page];
}

class LoadSimilarProductsEvent extends ProductDetailsEvent {
  final String productId;

  LoadSimilarProductsEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class SelectVariantEvent extends ProductDetailsEvent {
  final ProductVariant variant;

  SelectVariantEvent({required this.variant});

  @override
  List<Object?> get props => [variant];
}

class CreateReviewEvent extends ProductDetailsEvent {
  final CreateReviewRequest request;

  CreateReviewEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class MarkReviewHelpfulEvent extends ProductDetailsEvent {
  final String reviewId;
  final bool isHelpful;

  MarkReviewHelpfulEvent({
    required this.reviewId,
    required this.isHelpful,
  });

  @override
  List<Object?> get props => [reviewId, isHelpful];
}

// States
abstract class ProductDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductModel product;
  final ProductVariant? selectedVariant;
  final List<ProductModel> similarProducts;
  final List<ReviewModel> reviews;
  final ReviewSummary? reviewSummary;
  final bool hasMoreReviews;

  ProductDetailsLoaded({
    required this.product,
    this.selectedVariant,
    this.similarProducts = const [],
    this.reviews = const [],
    this.reviewSummary,
    this.hasMoreReviews = false,
  });

  @override
  List<Object?> get props => [
        product,
        selectedVariant,
        similarProducts,
        reviews,
        reviewSummary,
        hasMoreReviews,
      ];

  ProductDetailsLoaded copyWith({
    ProductModel? product,
    ProductVariant? selectedVariant,
    List<ProductModel>? similarProducts,
    List<ReviewModel>? reviews,
    ReviewSummary? reviewSummary,
    bool? hasMoreReviews,
  }) {
    return ProductDetailsLoaded(
      product: product ?? this.product,
      selectedVariant: selectedVariant,
      similarProducts: similarProducts ?? this.similarProducts,
      reviews: reviews ?? this.reviews,
      reviewSummary: reviewSummary ?? this.reviewSummary,
      hasMoreReviews: hasMoreReviews ?? this.hasMoreReviews,
    );
  }
}

class ReviewsLoading extends ProductDetailsState {}

class ReviewCreated extends ProductDetailsState {
  final ReviewModel review;
  final String message;

  ReviewCreated({
    required this.review,
    required this.message,
  });

  @override
  List<Object?> get props => [review, message];
}

class ProductDetailsError extends ProductDetailsState {
  final String message;

  ProductDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final GetProductReviewsUseCase getProductReviewsUseCase;
  final CreateReviewUseCase createReviewUseCase;
  final ProductsRepository productsRepository;

  ProductDetailsBloc({
    required this.getProductDetailsUseCase,
    required this.getProductReviewsUseCase,
    required this.createReviewUseCase,
    required this.productsRepository,
  }) : super(ProductDetailsInitial()) {
    on<LoadProductDetailsEvent>(_onLoadProductDetails);
    on<LoadProductReviewsEvent>(_onLoadProductReviews);
    on<LoadSimilarProductsEvent>(_onLoadSimilarProducts);
    on<SelectVariantEvent>(_onSelectVariant);
    on<CreateReviewEvent>(_onCreateReview);
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetailsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      final product = await getProductDetailsUseCase.execute(event.productId);

      // Select first variant if available
      final selectedVariant = product.hasVariants ? product.variants!.first : null;

      emit(ProductDetailsLoaded(
        product: product,
        selectedVariant: selectedVariant,
      ));

      // Load reviews and similar products in parallel
      add(LoadProductReviewsEvent(productId: event.productId));
      add(LoadSimilarProductsEvent(productId: event.productId));
    } catch (e) {
      emit(ProductDetailsError(message: e.toString()));
    }
  }

  Future<void> _onLoadProductReviews(
    LoadProductReviewsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;

      try {
        final reviews = await getProductReviewsUseCase.execute(
          event.productId,
          page: event.page,
          limit: 10,
        );

        // Merge with existing reviews if loading more
        final allReviews = event.page > 1
            ? [...currentState.reviews, ...reviews]
            : reviews;

        emit(currentState.copyWith(
          reviews: allReviews,
          hasMoreReviews: reviews.length >= 10,
        ));
      } catch (e) {
        // Don't change state if reviews fail to load
      }
    }
  }

  Future<void> _onLoadSimilarProducts(
    LoadSimilarProductsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;

      try {
        final similarProducts = await productsRepository.getSimilarProducts(
          event.productId,
          limit: 10,
        );

        emit(currentState.copyWith(similarProducts: similarProducts));
      } catch (e) {
        // Don't change state if similar products fail to load
      }
    }
  }

  void _onSelectVariant(
    SelectVariantEvent event,
    Emitter<ProductDetailsState> emit,
  ) {
    if (state is ProductDetailsLoaded) {
      final currentState = state as ProductDetailsLoaded;
      emit(currentState.copyWith(selectedVariant: event.variant));
    }
  }

  Future<void> _onCreateReview(
    CreateReviewEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    final previousState = state;

    emit(ReviewsLoading());
    try {
      final review = await createReviewUseCase.execute(event.request);

      emit(ReviewCreated(
        review: review,
        message: 'Review submitted successfully',
      ));

      // Reload reviews
      if (previousState is ProductDetailsLoaded) {
        add(LoadProductReviewsEvent(productId: event.request.productId));
        emit(previousState);
      }
    } catch (e) {
      emit(ProductDetailsError(message: e.toString()));
      if (previousState is ProductDetailsLoaded) {
        emit(previousState);
      }
    }
  }
}
