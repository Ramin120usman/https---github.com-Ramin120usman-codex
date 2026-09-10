import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import '../repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository _repository;

  HomeProvider({
    HomeRepository? repository,
  }) : _repository = repository ?? HomeRepository();

  bool isLoading = false;
  String? errorMessage;

  List<CategoryModel> categories = [];
  List<StoreModel> nearbyStores = [];
  List<ProductModel> trendingProducts = [];

  Future<void> loadHomeData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      categories = await _repository.getCategories();
    } catch (e) {
      debugPrint('Categories Error: $e');
    }

    try {
      nearbyStores = await _repository.getNearbyStores();
    } catch (e) {
      debugPrint('Nearby Stores Error: $e');
    }

    try {
      trendingProducts = await _repository.getTrendingProducts();
    } catch (e) {
      debugPrint('Trending Products Error: $e');
    }

    isLoading = false;
    notifyListeners();
  }
}