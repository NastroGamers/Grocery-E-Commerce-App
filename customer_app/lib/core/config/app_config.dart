class AppConfig {
  static const String appName = 'FreshCart';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://api.freshcart.com/v1';
  static const String socketUrl = 'wss://api.freshcart.com';

  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/categories';
  static const String cartEndpoint = '/cart';
  static const String wishlistEndpoint = '/wishlist';
  static const String ordersEndpoint = '/orders';
  static const String userEndpoint = '/user';
  static const String addressEndpoint = '/address';
  static const String couponsEndpoint = '/coupons';
  static const String paymentsEndpoint = '/payments';
  static const String reviewsEndpoint = '/reviews';
  static const String notificationsEndpoint = '/notifications';
  static const String supportEndpoint = '/support';

  // Google Maps API Key
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  // Payment Gateway Keys
  static const String razorpayKey = 'YOUR_RAZORPAY_KEY';
  static const String stripePublishableKey = 'YOUR_STRIPE_KEY';

  // Firebase
  static const String firebaseProjectId = 'grocery-ecommerce-app';

  // App Configuration
  static const int otpExpiryMinutes = 5;
  static const int sessionTimeoutMinutes = 30;
  static const int maxCartItems = 50;
  static const int searchDebounceMilliseconds = 300;
  static const int locationUpdateIntervalSeconds = 10;

  // Pagination
  static const int productsPerPage = 20;
  static const int ordersPerPage = 10;

  // Cache
  static const int cacheExpiryHours = 24;

  // Security
  static const int maxOtpAttempts = 3;
  static const int maxLoginAttempts = 5;
}
