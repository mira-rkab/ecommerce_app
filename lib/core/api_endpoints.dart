

class ApiEndpoints {
  ApiEndpoints._();

  // Authentication
  static const String login = '/api/v1/users/login';
  static const String register = '/api/v1/users/register';
  static const String profile = '/api/v1/users/profile';
  static const String logout = '/api/v1/users/logout';
  static String productDetails(int id) => '/api/v1/products/show_product/$id';
  static String updateOrderStatus(int id) => '/api/v1/orders/$id/status';

  // Products
  static const String products = '/api/v1/products/all_products';
  static const String createProduct = '/api/v1/products/create';

  // Orders
  static const String createOrder = '/api/v1/orders/create';
  static const String getOrders = '/api/v1/orders/get_order';
}
