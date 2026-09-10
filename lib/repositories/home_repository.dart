import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';

class HomeRepository {
  final DioClient _dioClient;

  HomeRepository({
    DioClient? dioClient,
  }) : _dioClient = dioClient ?? DioClient();

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dioClient.dio.get(
        '/api/v1/customer/store-categories',
        queryParameters: {
          'page': 1,
          'limit': 20,
          'search': 'a',
        },
      );

      final responseData = response.data;

      if (responseData is! Map) {
        return [];
      }

      final data = responseData['data'];

      if (data is List) {
        return data
            .map(
              (item) => CategoryModel.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      }

      if (data is Map) {
        final items = data['items'];

        if (items is List) {
          return items
              .map(
                (item) => CategoryModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();
        }
      }

      return [];
    } on DioException catch (e) {
      print('Categories API Error: ${e.response?.data ?? e.message}');
      return [];
    }
  }

  Future<List<StoreModel>> getNearbyStores() async {
    try {
      final response = await _dioClient.dio.get(
        '/api/v1/customer/stores/nearby',
        queryParameters: {
          'lat': 12.9716,
          'lng': 77.5946,
          'page': 1,
          'limit': 20,
        },
      );

      final responseData = response.data;

      if (responseData is! Map) {
        return [];
      }

      final data = responseData['data'];

      if (data is Map) {
        final items = data['items'];

        if (items is List) {
          return items
              .map(
                (item) => StoreModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();
        }
      }

      return [];
    } on DioException catch (e) {
      print('Nearby Stores API Error: ${e.response?.data ?? e.message}');
      return [];
    }
  }

  Future<List<ProductModel>> getTrendingProducts() async {
    try {
      final response = await _dioClient.dio.get(
        '/api/v1/customer/offers/trending',
        queryParameters: {
          'page': 1,
          'limit': 20,
        },
      );

      final responseData = response.data;

      if (responseData is! Map) {
        return [];
      }

      final data = responseData['data'];

      if (data is Map) {
        final items = data['items'];

        if (items is List) {
          return items
              .map(
                (item) => ProductModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();
        }
      }

      return [];
    } on DioException catch (e) {
      print('Trending Products API Error: ${e.response?.data ?? e.message}');
      return [];
    }
  }
}