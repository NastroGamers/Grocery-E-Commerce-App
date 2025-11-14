import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import '../../domain/usecases/get_featured_products_usecase.dart';

// Events
abstract class ProductsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends ProductsEvent {}

class LoadProductsEvent extends ProductsEvent {
  final ProductFilter filter;
  final bool loadMore; // For pagination

  LoadProductsEvent({
    required this.filter,
    this.loadMore = false,
  });

  @override
  List<Object?> get props => [filter, loadMore];
}

class ApplyFiltersEvent extends ProductsEvent {
  final ProductFilter filter;

  ApplyFiltersEvent({required this.filter});

  @override
  List<Object?> get props => [filter];
}

class ChangeSortOptionEvent extends ProductsEvent {
  final ProductSortOption sortOption;

  ChangeSortOptionEvent({required this.sortOption});

  @override
  List<Object?> get props => [sortOption];
}

class LoadFeaturedProductsEvent extends ProductsEvent {}

class LoadFlashSaleProductsEvent extends ProductsEvent {}

class LoadProductDetailsEvent extends ProductsEvent {
  final String productId;

  LoadProductDetailsEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class RefreshProductsEvent extends ProductsEvent {}

// States
abstract class ProductsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class CategoriesLoaded extends ProductsState {
  final List<CategoryModel> categories;

  CategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class ProductsLoaded extends ProductsState {
  final List<ProductModel> products;
  final ProductFilter currentFilter;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;
  final bool isLoadingMore;

  ProductsLoaded({
    required this.products,
    required this.currentFilter,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
        products,
        currentFilter,
        totalCount,
        currentPage,
        totalPages,
        hasNextPage,
        isLoadingMore,
      ];

  ProductsLoaded copyWith({
    List<ProductModel>? products,
    ProductFilter? currentFilter,
    int? totalCount,
    int? currentPage,
    int? totalPages,
    bool? hasNextPage,
    bool? isLoadingMore,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      currentFilter: currentFilter ?? this.currentFilter,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class FeaturedProductsLoaded extends ProductsState {
  final List<ProductModel> featuredProducts;

  FeaturedProductsLoaded({required this.featuredProducts});

  @override
  List<Object?> get props => [featuredProducts];
}

class ProductDetailsLoaded extends ProductsState {
  final ProductModel product;

  ProductDetailsLoaded({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductsEmpty extends ProductsState {
  final String message;

  ProductsEmpty({this.message = 'No products found'});

  @override
  List<Object?> get props => [message];
}

// Bloc
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final GetFeaturedProductsUseCase getFeaturedProductsUseCase;

  ProductsBloc({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
    required this.getProductDetailsUseCase,
    required this.getFeaturedProductsUseCase,
  }) : super(ProductsInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadProductsEvent>(_onLoadProducts);
    on<ApplyFiltersEvent>(_onApplyFilters);
    on<ChangeSortOptionEvent>(_onChangeSortOption);
    on<LoadFeaturedProductsEvent>(_onLoadFeaturedProducts);
    on<LoadProductDetailsEvent>(_onLoadProductDetails);
    on<RefreshProductsEvent>(_onRefreshProducts);
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final categories = await getCategoriesUseCase.execute();
      emit(CategoriesLoaded(categories: categories));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    // If loading more, show loading indicator in current state
    if (event.loadMore && state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      emit(currentState.copyWith(isLoadingMore: true));
    } else {
      emit(ProductsLoading());
    }

    try {
      final response = await getProductsUseCase.execute(event.filter);

      if (response.products.isEmpty && !event.loadMore) {
        emit(ProductsEmpty());
        return;
      }

      // If loading more, append to existing products
      List<ProductModel> allProducts = response.products;
      if (event.loadMore && state is ProductsLoaded) {
        final currentState = state as ProductsLoaded;
        allProducts = [...currentState.products, ...response.products];
      }

      emit(ProductsLoaded(
        products: allProducts,
        currentFilter: event.filter,
        totalCount: response.totalCount,
        currentPage: response.page,
        totalPages: response.totalPages,
        hasNextPage: response.hasNextPage,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onApplyFilters(
    ApplyFiltersEvent event,
    Emitter<ProductsState> emit,
  ) async {
    // Reset to page 1 when applying new filters
    final filter = event.filter.copyWith(page: 1);
    add(LoadProductsEvent(filter: filter));
  }

  Future<void> _onChangeSortOption(
    ChangeSortOptionEvent event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      final updatedFilter = currentState.currentFilter.copyWith(
        sortBy: event.sortOption,
        page: 1, // Reset to first page when changing sort
      );
      add(LoadProductsEvent(filter: updatedFilter));
    }
  }

  Future<void> _onLoadFeaturedProducts(
    LoadFeaturedProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final products = await getFeaturedProductsUseCase.execute(limit: 10);
      emit(FeaturedProductsLoaded(featuredProducts: products));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onLoadProductDetails(
    LoadProductDetailsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final product = await getProductDetailsUseCase.execute(event.productId);
      emit(ProductDetailsLoaded(product: product));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      // Reset to page 1 and reload
      final filter = currentState.currentFilter.copyWith(page: 1);
      add(LoadProductsEvent(filter: filter));
    } else {
      // Load with default filter
      add(LoadProductsEvent(filter: ProductFilter()));
    }
  }
}
