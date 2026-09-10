import 'package:flutter/material.dart';

import '../models/wishlist_model.dart';
import '../repositories/wishlist_repository.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistRepository _repository;

  WishlistProvider({
    WishlistRepository? repository,
  }) : _repository = repository ?? WishlistRepository();

  bool isLoading = false;
  bool isUpdating = false;

  String? errorMessage;

  List<WishlistItemModel> items = [];

  Future<void> loadWishlist() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      items = await _repository.getWishlist();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToWishlist({
    required String productId,
  }) async {
    isUpdating = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.addToWishlist(
        productId: productId,
      );

      await loadWishlist();

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> removeFromWishlist(
    String productId,
  ) async {
    isUpdating = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repository.removeFromWishlist(
        productId,
      );

      items.removeWhere(
        (item) => item.productId == productId,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  bool isWishlisted(String productId) {
    return items.any(
      (item) => item.productId == productId,
    );
  }
}