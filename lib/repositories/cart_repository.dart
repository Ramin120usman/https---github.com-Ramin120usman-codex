import '../core/network/dio_client.dart';

class CartRepository {
  final DioClient _dioClient;

  CartRepository({
    DioClient? dioClient,
  }) : _dioClient = dioClient ?? DioClient();

  Future<dynamic> getCart() async {
    final response = await _dioClient.dio.get(
      '/api/v1/customer/cart',
    );

    return response.data;
  }

  Future<dynamic> addCartItem({
    required String storeId,
    required String productId,
    required String productType,
    required int qty,
  }) async {
    final response = await _dioClient.dio.post(
      '/api/v1/customer/cart/items',
      data: {
        'storeId': storeId,
        'productId': productId,
        'productType': productType,
        'qty': qty,
      },
    );

    return response.data;
  }

  Future<dynamic> updateCartItem({
    required String itemId,
    required int qty,
  }) async {
    final response = await _dioClient.dio.patch(
      '/api/v1/customer/cart/items/$itemId',
      data: {
        'qty': qty,
      },
    );

    return response.data;
  }

  Future<dynamic> removeCartItem(String itemId) async {
    final response = await _dioClient.dio.delete(
      '/api/v1/customer/cart/items/$itemId',
    );

    return response.data;
  }

  Future<dynamic> getCartSummary(String storeId) async {
    final response = await _dioClient.dio.get(
      '/api/v1/customer/cart/$storeId/summary',
    );

    return response.data;
  }
}