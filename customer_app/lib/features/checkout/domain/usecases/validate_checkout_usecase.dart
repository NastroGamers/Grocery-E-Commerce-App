import '../repositories/checkout_repository.dart';
import '../../data/models/order_model.dart';

class ValidateCheckoutUseCase {
  final CheckoutRepository repository;

  ValidateCheckoutUseCase(this.repository);

  /// Calculate order summary with all fees and discounts
  Future<OrderSummary> calculateOrderSummary({
    required List<OrderItemModel> items,
    required String deliveryAddressId,
    String? couponCode,
  }) async {
    // Validate items
    if (items.isEmpty) {
      throw Exception('Cart is empty. Please add items to proceed.');
    }

    // Validate each item
    for (final item in items) {
      if (item.quantity <= 0) {
        throw Exception('Invalid quantity for ${item.productName}');
      }

      if (item.priceAtOrder < 0) {
        throw Exception('Invalid price for ${item.productName}');
      }
    }

    // Validate delivery address
    if (deliveryAddressId.isEmpty) {
      throw Exception('Please select a delivery address');
    }

    return await repository.calculateOrderSummary(
      items: items,
      deliveryAddressId: deliveryAddressId,
      couponCode: couponCode,
    );
  }

  /// Check stock availability for all items in cart
  Future<CheckStockAvailabilityResponse> checkStockAvailability({
    required List<OrderItemModel> items,
  }) async {
    if (items.isEmpty) {
      throw Exception('No items to check');
    }

    final checkStockItems = items.map((item) {
      return CheckStockItem(
        productId: item.productId,
        quantity: item.quantity,
        variantId: item.variantId,
      );
    }).toList();

    final request = CheckStockAvailabilityRequest(items: checkStockItems);

    final response = await repository.checkStockAvailability(request);

    // If any items are unavailable, throw an exception with details
    if (!response.allAvailable) {
      final unavailableItems = response.unavailableItems;

      if (unavailableItems.length == 1) {
        final item = unavailableItems.first;
        throw Exception(
          '${item.productName} is ${item.availableQuantity > 0
            ? "only available in quantity of ${item.availableQuantity}"
            : "out of stock"}. Please update your cart.'
        );
      } else {
        final itemNames = unavailableItems
            .map((item) => item.productName)
            .take(3)
            .join(', ');

        throw Exception(
          'Some items are out of stock: $itemNames${unavailableItems.length > 3
            ? " and ${unavailableItems.length - 3} more"
            : ""}. Please update your cart.'
        );
      }
    }

    return response;
  }

  /// Validate checkout data before creating order
  Future<bool> validateCheckout({
    required List<OrderItemModel> items,
    required String deliveryAddressId,
    required String deliverySlotId,
    required DateTime deliveryDate,
    required PaymentMethod paymentMethod,
  }) async {
    // Validate items
    if (items.isEmpty) {
      throw Exception('Cart is empty');
    }

    // Validate delivery address
    if (deliveryAddressId.isEmpty) {
      throw Exception('Please select a delivery address');
    }

    // Validate delivery slot
    if (deliverySlotId.isEmpty) {
      throw Exception('Please select a delivery time slot');
    }

    // Validate delivery date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final requestDate = DateTime(deliveryDate.year, deliveryDate.month, deliveryDate.day);

    if (requestDate.isBefore(today)) {
      throw Exception('Invalid delivery date');
    }

    // Check stock availability
    await checkStockAvailability(items: items);

    return true;
  }
}
