import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_datasource.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CartSummary> getCart() async {
    return await remoteDataSource.getCart();
  }

  @override
  Future<CartItemModel> addToCart(AddToCartRequest request) async {
    return await remoteDataSource.addToCart(request);
  }

  @override
  Future<CartItemModel> updateCartItem(String cartItemId, int quantity) async {
    return await remoteDataSource.updateCartItem(
      cartItemId,
      UpdateCartItemRequest(quantity: quantity),
    );
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    await remoteDataSource.removeFromCart(cartItemId);
  }

  @override
  Future<void> clearCart() async {
    await remoteDataSource.clearCart();
  }

  @override
  Future<CartSummary> syncCart(List<Map<String, dynamic>> localCartItems) async {
    return await remoteDataSource.syncCart(localCartItems);
  }

  @override
  Future<List<WishlistItemModel>> getWishlist() async {
    return await remoteDataSource.getWishlist();
  }

  @override
  Future<WishlistItemModel> addToWishlist(String productId) async {
    return await remoteDataSource.addToWishlist(productId);
  }

  @override
  Future<void> removeFromWishlist(String wishlistItemId) async {
    await remoteDataSource.removeFromWishlist(wishlistItemId);
  }

  @override
  Future<void> moveToCart(String wishlistItemId) async {
    await remoteDataSource.moveToCart(wishlistItemId);
  }

  @override
  Future<bool> isInWishlist(String productId) async {
    final wishlist = await getWishlist();
    return wishlist.any((item) => item.productId == productId);
  }
}
