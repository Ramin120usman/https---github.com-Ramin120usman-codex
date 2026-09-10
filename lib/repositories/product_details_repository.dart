import '../core/network/dio_client.dart';
import '../models/product_model.dart';

class ProductDetailsRepository {
  final DioClient _dioClient;

  ProductDetailsRepository({
    DioClient? dioClient,
  }) : _dioClient = dioClient ?? DioClient();

  Future<ProductModel> getProductDetails(String productId) async {
    final response = await _dioClient.dio.get(
      '/api/v1/customer/products/$productId',
    );

    final data = response.data['data'];

    if (data is Map<String, dynamic>) {
      return ProductModel.fromJson(data);
    }

    throw Exception('Invalid product response');
  }
}