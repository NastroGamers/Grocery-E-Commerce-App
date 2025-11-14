import '../../../../core/network/dio_client.dart';
import '../../../../core/config/app_config.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartSummary> getCart();
  Future<CartItemModel> addToCart(AddToCartRequest request);
  Future<CartItemModel> updateCartItem(String cartItemId, UpdateCartItemRequest request);
  Future<void> removeFromCart(String cartItemId);
  Future<void> clearCart();
  Future<CartSummary> syncCart(List<Map<String, dynamic>> localCartItems);

  // Wishlist
  Future<List<WishlistItemModel>> getWishlist();
  Future<WishlistItemModel> addToWishlist(String productId);
  Future<void> removeFromWishlist(String wishlistItemId);
  Future<void> moveToCart(String wishlistItemId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final DioClient _dioClient;

  CartRemoteDataSourceImpl(this._dioClient);

  @override
  Future<CartSummary> getCart() async {
    try {
      final response = await _dioClient.get(AppConfig.cartEndpoint);
      return CartSummary.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CartItemModel> addToCart(AddToCartRequest request) async {
    try {
      final response = await _dioClient.post(
        '${AppConfig.cartEndpoint}/add',
        data: request.toJson(),
      );
      return CartItemModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CartItemModel> updateCartItem(
    String cartItemId,
    UpdateCartItemRequest request,
  ) async {
    try {
      final response = await _dioClient.put(
        '${AppConfig.cartEndpoint}/update/$cartItemId',
        data: request.toJson(),
      );
      return CartItemModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromCart(String cartItemId) async {
    try {
      await _dioClient.delete('${AppConfig.cartEndpoint}/remove/$cartItemId');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _dioClient.delete('${AppConfig.cartEndpoint}/clear');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CartSummary> syncCart(List<Map<String, dynamic>> localCartItems) async {
    try {
      final response = await _dioClient.post(
        '${AppConfig.cartEndpoint}/sync',
        data: {'items': localCartItems},
      );
      return CartSummary.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<WishlistItemModel>> getWishlist() async {
    try {
      final response = await _dioClient.get(AppConfig.wishlistEndpoint);
      final List<dynamic> data = response.data['data'] as List;
      return data.map((json) => WishlistItemModel.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WishlistItemModel> addToWishlist(String productId) async {
    try {
      final response = await _dioClient.post(
        '${AppConfig.wishlistEndpoint}/add',
        data: {'productId': productId},
      );
      return WishlistItemModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromWishlist(String wishlistItemId) async {
    try {
      await _dioClient.delete('${AppConfig.wishlistEndpoint}/remove/$wishlistItemId');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> moveToCart(String wishlistItemId) async {
    try {
      await _dioClient.post('${AppConfig.wishlistEndpoint}/$wishlistItemId/move-to-cart');
    } catch (e) {
      rethrow;
    }
  }
}
