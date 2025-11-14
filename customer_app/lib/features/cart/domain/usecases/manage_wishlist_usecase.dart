import '../repositories/cart_repository.dart';
import '../../data/models/cart_model.dart';

class ManageWishlistUseCase {
  final CartRepository repository;

  ManageWishlistUseCase(this.repository);

  Future<List<WishlistItemModel>> getWishlist() async {
    return await repository.getWishlist();
  }

  Future<WishlistItemModel> addToWishlist(String productId) async {
    return await repository.addToWishlist(productId);
  }

  Future<void> removeFromWishlist(String wishlistItemId) async {
    await repository.removeFromWishlist(wishlistItemId);
  }

  Future<void> moveToCart(String wishlistItemId) async {
    await repository.moveToCart(wishlistItemId);
  }

  Future<bool> isInWishlist(String productId) async {
    return await repository.isInWishlist(productId);
  }
}
