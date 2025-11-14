import '../repositories/cart_repository.dart';
import '../../data/models/cart_model.dart';

class ManageCartUseCase {
  final CartRepository repository;

  ManageCartUseCase(this.repository);

  Future<CartSummary> getCart() async {
    return await repository.getCart();
  }

  Future<CartItemModel> addToCart(AddToCartRequest request) async {
    // Validate quantity
    if (request.quantity <= 0) {
      throw Exception('Quantity must be greater than 0');
    }

    if (request.quantity > 99) {
      throw Exception('Maximum quantity per item is 99');
    }

    return await repository.addToCart(request);
  }

  Future<CartItemModel> updateQuantity(String cartItemId, int quantity) async {
    // Validate quantity
    if (quantity <= 0) {
      throw Exception('Quantity must be greater than 0');
    }

    if (quantity > 99) {
      throw Exception('Maximum quantity per item is 99');
    }

    return await repository.updateCartItem(cartItemId, quantity);
  }

  Future<void> removeItem(String cartItemId) async {
    await repository.removeFromCart(cartItemId);
  }

  Future<void> clearCart() async {
    await repository.clearCart();
  }
}
