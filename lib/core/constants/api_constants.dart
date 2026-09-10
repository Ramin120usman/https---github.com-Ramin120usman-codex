class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://outmesmart.codeedextechnologies.com';

  // Auth
  static const String requestOtp =
      '/api/v1/customer/auth/otp/request';

  static const String verifyOtp =
      '/api/v1/customer/auth/otp/verify';

  static const String refreshToken =
      '/api/v1/customer/auth/refresh';

  static const String logout =
      '/api/v1/customer/auth/logout';

  // Homepage
  static const String storeCategories =
      '/api/v1/customer/store-categories';

  static const String nearbyStores =
      '/api/v1/customer/stores/nearby';

  static const String trendingProducts =
      '/api/v1/customer/offers/trending';

  // Cart
  static const String cart =
      '/api/v1/customer/cart';

  static const String cartItems =
      '/api/v1/customer/cart/items';

  static String storeCart(String storeId) =>
      '/api/v1/customer/cart/$storeId';

  static String cartSummary(String storeId) =>
      '/api/v1/customer/cart/$storeId/summary';

  static String cartItem(String id) =>
      '/api/v1/customer/cart/items/$id';
}