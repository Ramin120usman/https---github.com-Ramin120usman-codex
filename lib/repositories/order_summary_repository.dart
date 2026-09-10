import '../core/network/dio_client.dart';

class OrderSummaryRepository {
  final DioClient _dioClient;

  OrderSummaryRepository({
    DioClient? dioClient,
  }) : _dioClient = dioClient ?? DioClient();

  Future<Map<String, dynamic>> getOrderSummary({
    required String storeId,
  }) async {
    final response = await _dioClient.dio.get(
      '/api/v1/customer/cart/$storeId/summary',
    );

    final data = response.data['data'];

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return {};
  }
}