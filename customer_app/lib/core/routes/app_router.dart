import 'package:flutter/material.dart';

// Screens will be imported as they're created
class AppRouter {
  // Route Names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String locationSelection = '/location-selection';
  static const String categories = '/categories';
  static const String productList = '/products';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String checkout = '/checkout';
  static const String deliverySlots = '/delivery-slots';
  static const String payment = '/payment';
  static const String orderConfirmation = '/order-confirmation';
  static const String orderTracking = '/order-tracking';
  static const String orderHistory = '/order-history';
  static const String orderDetail = '/order-detail';
  static const String profile = '/profile';
  static const String addresses = '/addresses';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';
  static const String notifications = '/notifications';
  static const String search = '/search';
  static const String coupons = '/coupons';
  static const String support = '/support';
  static const String chat = '/chat';
  static const String reviews = '/reviews';
  static const String writeReview = '/write-review';
  static const String settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(
          const SplashScreen(),
          settings: settings,
        );

      case onboarding:
        return _buildRoute(
          const OnboardingScreen(),
          settings: settings,
        );

      case login:
        return _buildRoute(
          const LoginScreen(),
          settings: settings,
        );

      case register:
        return _buildRoute(
          const RegisterScreen(),
          settings: settings,
        );

      case otpVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          OtpVerificationScreen(
            phoneNumber: args?['phoneNumber'] ?? '',
            email: args?['email'] ?? '',
          ),
          settings: settings,
        );

      case home:
        return _buildRoute(
          const HomeScreen(),
          settings: settings,
        );

      case locationSelection:
        return _buildRoute(
          const LocationSelectionScreen(),
          settings: settings,
        );

      case categories:
        return _buildRoute(
          const CategoriesScreen(),
          settings: settings,
        );

      case productList:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          ProductListScreen(
            categoryId: args?['categoryId'],
            categoryName: args?['categoryName'] ?? '',
          ),
          settings: settings,
        );

      case productDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          ProductDetailScreen(
            productId: args['productId'] as String,
          ),
          settings: settings,
        );

      case cart:
        return _buildRoute(
          const CartScreen(),
          settings: settings,
        );

      case wishlist:
        return _buildRoute(
          const WishlistScreen(),
          settings: settings,
        );

      case checkout:
        return _buildRoute(
          const CheckoutScreen(),
          settings: settings,
        );

      case deliverySlots:
        return _buildRoute(
          const DeliverySlotsScreen(),
          settings: settings,
        );

      case payment:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          PaymentScreen(
            orderId: args['orderId'] as String,
            amount: args['amount'] as double,
          ),
          settings: settings,
        );

      case orderConfirmation:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          OrderConfirmationScreen(
            orderId: args['orderId'] as String,
          ),
          settings: settings,
        );

      case orderTracking:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          OrderTrackingScreen(
            orderId: args['orderId'] as String,
          ),
          settings: settings,
        );

      case orderHistory:
        return _buildRoute(
          const OrderHistoryScreen(),
          settings: settings,
        );

      case orderDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          OrderDetailScreen(
            orderId: args['orderId'] as String,
          ),
          settings: settings,
        );

      case profile:
        return _buildRoute(
          const ProfileScreen(),
          settings: settings,
        );

      case addresses:
        return _buildRoute(
          const AddressesScreen(),
          settings: settings,
        );

      case addAddress:
        return _buildRoute(
          const AddAddressScreen(),
          settings: settings,
        );

      case editAddress:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          EditAddressScreen(
            addressId: args['addressId'] as String,
          ),
          settings: settings,
        );

      case notifications:
        return _buildRoute(
          const NotificationsScreen(),
          settings: settings,
        );

      case search:
        return _buildRoute(
          const SearchScreen(),
          settings: settings,
        );

      case coupons:
        return _buildRoute(
          const CouponsScreen(),
          settings: settings,
        );

      case support:
        return _buildRoute(
          const SupportScreen(),
          settings: settings,
        );

      case chat:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          ChatScreen(
            ticketId: args?['ticketId'],
          ),
          settings: settings,
        );

      case reviews:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          ReviewsScreen(
            productId: args['productId'] as String,
          ),
          settings: settings,
        );

      case writeReview:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          WriteReviewScreen(
            orderId: args['orderId'] as String,
            productId: args['productId'] as String,
          ),
          settings: settings,
        );

      case settings:
        return _buildRoute(
          const SettingsScreen(),
          settings: settings,
        );

      default:
        return _buildRoute(
          const NotFoundScreen(),
          settings: settings,
        );
    }
  }

  static MaterialPageRoute _buildRoute(
    Widget page, {
    required RouteSettings settings,
  }) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}

// Placeholder screens - will be replaced with actual implementations
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Splash')));
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Onboarding')));
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Login')));
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Register')));
}

class OtpVerificationScreen extends StatelessWidget {
  final String phoneNumber;
  final String email;
  const OtpVerificationScreen({super.key, this.phoneNumber = '', this.email = ''});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('OTP')));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Home')));
}

class LocationSelectionScreen extends StatelessWidget {
  const LocationSelectionScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Location')));
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Categories')));
}

class ProductListScreen extends StatelessWidget {
  final String? categoryId;
  final String categoryName;
  const ProductListScreen({super.key, this.categoryId, this.categoryName = ''});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Products')));
}

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Product Detail')));
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Cart')));
}

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Wishlist')));
}

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Checkout')));
}

class DeliverySlotsScreen extends StatelessWidget {
  const DeliverySlotsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Delivery Slots')));
}

class PaymentScreen extends StatelessWidget {
  final String orderId;
  final double amount;
  const PaymentScreen({super.key, required this.orderId, required this.amount});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Payment')));
}

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  const OrderConfirmationScreen({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Order Confirmed')));
}

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Track Order')));
}

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Order History')));
}

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Order Detail')));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Profile')));
}

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Addresses')));
}

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Add Address')));
}

class EditAddressScreen extends StatelessWidget {
  final String addressId;
  const EditAddressScreen({super.key, required this.addressId});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Edit Address')));
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Notifications')));
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Search')));
}

class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Coupons')));
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Support')));
}

class ChatScreen extends StatelessWidget {
  final String? ticketId;
  const ChatScreen({super.key, this.ticketId});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Chat')));
}

class ReviewsScreen extends StatelessWidget {
  final String productId;
  const ReviewsScreen({super.key, required this.productId});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Reviews')));
}

class WriteReviewScreen extends StatelessWidget {
  final String orderId;
  final String productId;
  const WriteReviewScreen({super.key, required this.orderId, required this.productId});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Write Review')));
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Settings')));
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('404 Not Found')));
}
