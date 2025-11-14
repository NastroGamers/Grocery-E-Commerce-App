import '../../data/models/cart_model.dart';

abstract class CartRepository {
  // Cart operations
  Future<CartSummary> getCart();
  Future<CartItemModel> addToCart(AddToCartRequest request);
  Future<CartItemModel> updateCartItem(String cartItemId, int quantity);
  Future<void> removeFromCart(String cartItemId);
  Future<void> clearCart();
  Future<CartSummary> syncCart(List<Map<String, dynamic>> localCartItems);

  // Wishlist operations
  Future<List<WishlistItemModel>> getWishlist();
  Future<WishlistItemModel> addToWishlist(String productId);
  Future<void> removeFromWishlist(String wishlistItemId);
  Future<void> moveToCart(String wishlistItemId);
  Future<bool> isInWishlist(String productId);
}
