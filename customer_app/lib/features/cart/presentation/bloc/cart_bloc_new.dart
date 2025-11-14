import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/cart_model.dart';
import '../../domain/usecases/manage_cart_usecase.dart';
import '../../domain/usecases/manage_wishlist_usecase.dart';

// Events
abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final AddToCartRequest request;

  AddToCartEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class UpdateCartItemQuantityEvent extends CartEvent {
  final String cartItemId;
  final int quantity;

  UpdateCartItemQuantityEvent({
    required this.cartItemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [cartItemId, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final String cartItemId;

  RemoveFromCartEvent({required this.cartItemId});

  @override
  List<Object?> get props => [cartItemId];
}

class ClearCartEvent extends CartEvent {}

class LoadWishlistEvent extends CartEvent {}

class AddToWishlistEvent extends CartEvent {
  final String productId;

  AddToWishlistEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class RemoveFromWishlistEvent extends CartEvent {
  final String wishlistItemId;

  RemoveFromWishlistEvent({required this.wishlistItemId});

  @override
  List<Object?> get props => [wishlistItemId];
}

class MoveToCartFromWishlistEvent extends CartEvent {
  final String wishlistItemId;

  MoveToCartFromWishlistEvent({required this.wishlistItemId});

  @override
  List<Object?> get props => [wishlistItemId];
}

// States
abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartSummary cart;

  CartLoaded({required this.cart});

  @override
  List<Object?> get props => [cart];

  bool get isEmpty => cart.isEmpty;
  int get itemCount => cart.itemCount;
  double get total => cart.total;
}

class CartItemAdded extends CartState {
  final CartItemModel item;
  final String message;

  CartItemAdded({
    required this.item,
    required this.message,
  });

  @override
  List<Object?> get props => [item, message];
}

class CartItemRemoved extends CartState {
  final String message;

  CartItemRemoved({required this.message});

  @override
  List<Object?> get props => [message];
}

class WishlistLoaded extends CartState {
  final List<WishlistItemModel> wishlist;

  WishlistLoaded({required this.wishlist});

  @override
  List<Object?> get props => [wishlist];

  bool get isEmpty => wishlist.isEmpty;
  int get count => wishlist.length;
}

class WishlistItemAdded extends CartState {
  final WishlistItemModel item;
  final String message;

  WishlistItemAdded({
    required this.item,
    required this.message,
  });

  @override
  List<Object?> get props => [item, message];
}

class WishlistItemRemoved extends CartState {
  final String message;

  WishlistItemRemoved({required this.message});

  @override
  List<Object?> get props => [message];
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class CartBlocNew extends Bloc<CartEvent, CartState> {
  final ManageCartUseCase manageCartUseCase;
  final ManageWishlistUseCase manageWishlistUseCase;

  CartBlocNew({
    required this.manageCartUseCase,
    required this.manageWishlistUseCase,
  }) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateCartItemQuantityEvent>(_onUpdateCartItemQuantity);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
    on<LoadWishlistEvent>(_onLoadWishlist);
    on<AddToWishlistEvent>(_onAddToWishlist);
    on<RemoveFromWishlistEvent>(_onRemoveFromWishlist);
    on<MoveToCartFromWishlistEvent>(_onMoveToCartFromWishlist);
  }

  Future<void> _onLoadCart(
    LoadCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final cart = await manageCartUseCase.getCart();
      emit(CartLoaded(cart: cart));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final previousState = state;
    emit(CartLoading());

    try {
      final item = await manageCartUseCase.addToCart(event.request);

      emit(CartItemAdded(
        item: item,
        message: 'Item added to cart',
      ));

      // Reload cart
      add(LoadCartEvent());
    } catch (e) {
      emit(CartError(message: e.toString()));
      if (previousState is CartLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentState = state as CartLoaded;

      try {
        await manageCartUseCase.updateQuantity(
          event.cartItemId,
          event.quantity,
        );

        // Reload cart
        add(LoadCartEvent());
      } catch (e) {
        emit(CartError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final previousState = state;
    emit(CartLoading());

    try {
      await manageCartUseCase.removeItem(event.cartItemId);

      emit(CartItemRemoved(message: 'Item removed from cart'));

      // Reload cart
      add(LoadCartEvent());
    } catch (e) {
      emit(CartError(message: e.toString()));
      if (previousState is CartLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      await manageCartUseCase.clearCart();
      emit(CartLoaded(cart: CartSummary(
        items: [],
        subtotal: 0,
        total: 0,
        itemCount: 0,
        uniqueItemCount: 0,
      )));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onLoadWishlist(
    LoadWishlistEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final wishlist = await manageWishlistUseCase.getWishlist();
      emit(WishlistLoaded(wishlist: wishlist));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onAddToWishlist(
    AddToWishlistEvent event,
    Emitter<CartState> emit,
  ) async {
    final previousState = state;

    try {
      final item = await manageWishlistUseCase.addToWishlist(event.productId);

      emit(WishlistItemAdded(
        item: item,
        message: 'Added to wishlist',
      ));

      // Reload wishlist
      add(LoadWishlistEvent());
    } catch (e) {
      emit(CartError(message: e.toString()));
      if (previousState is WishlistLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onRemoveFromWishlist(
    RemoveFromWishlistEvent event,
    Emitter<CartState> emit,
  ) async {
    final previousState = state;

    try {
      await manageWishlistUseCase.removeFromWishlist(event.wishlistItemId);

      emit(WishlistItemRemoved(message: 'Removed from wishlist'));

      // Reload wishlist
      add(LoadWishlistEvent());
    } catch (e) {
      emit(CartError(message: e.toString()));
      if (previousState is WishlistLoaded) {
        emit(previousState);
      }
    }
  }

  Future<void> _onMoveToCartFromWishlist(
    MoveToCartFromWishlistEvent event,
    Emitter<CartState> emit,
  ) async {
    final previousState = state;

    try {
      await manageWishlistUseCase.moveToCart(event.wishlistItemId);

      emit(CartItemAdded(
        item: CartItemModel(
          id: '',
          userId: '',
          productId: '',
          product: ProductModel(
            id: '',
            name: '',
            sku: '',
            description: '',
            images: [],
            price: 0,
            mrp: 0,
            categoryId: '',
            stockQuantity: 0,
            unit: '',
            createdAt: DateTime.now(),
          ),
          quantity: 1,
          priceAtAdd: 0,
          addedAt: DateTime.now(),
        ),
        message: 'Moved to cart',
      ));

      // Reload both cart and wishlist
      add(LoadCartEvent());
      add(LoadWishlistEvent());
    } catch (e) {
      emit(CartError(message: e.toString()));
      if (previousState is WishlistLoaded) {
        emit(previousState);
      }
    }
  }
}
