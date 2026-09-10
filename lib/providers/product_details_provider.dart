import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../repositories/product_details_repository.dart';

class ProductDetailsProvider extends ChangeNotifier {
  final ProductDetailsRepository _repository;

  ProductDetailsProvider({
    ProductDetailsRepository? repository,
  }) : _repository =
            repository ?? ProductDetailsRepository();

  ProductModel? product;

  bool isLoading = false;
  String? errorMessage;

  Future<void> loadProduct(String productId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      product = await _repository.getProductDetails(productId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}