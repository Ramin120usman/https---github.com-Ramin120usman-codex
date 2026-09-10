import '../core/network/dio_client.dart';
import '../models/wishlist_model.dart';

class WishlistRepository {
  final DioClient _dioClient;

  WishlistRepository({
    DioClient? dioClient,
  }) : _dioClient = dioClient ?? DioClient();

  Future<List<WishlistItemModel>> getWishlist() async {
    final response = await _dioClient.dio.get(
      '/api/v1/customer/wishlist',
    );

    final data = response.data['data'];

    if (data is List) {
      return data
          .whereType<Map>()
          .map(
            (item) => WishlistItemModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    }

    return [];
  }

  Future<bool> addToWishlist({
    required String productId,
  }) async {
    await _dioClient.dio.post(
      '/api/v1/customer/wishlist',
      data: {
        'productId': productId,
      },
    );

    return true;
  }

  Future<bool> removeFromWishlist(String productId) async {
    await _dioClient.dio.delete(
      '/api/v1/customer/wishlist/$productId',
    );

    return true;
  }
}