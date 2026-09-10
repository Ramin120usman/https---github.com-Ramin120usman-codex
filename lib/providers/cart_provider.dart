import 'package:flutter/material.dart';

import '../models/cart_model.dart';
import '../repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repository;

  CartProvider({
    CartRepository? repository,
  }) : _repository = repository ?? CartRepository();

  bool isLoading = false;
  bool isUpdating = false;

  String? errorMessage;

  List<CartModel> carts = [];

  Future<void> loadCart() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      carts = await _repository.getCart();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart({
    required String storeId,
    required String productId,
    required String productType,
    int qty = 1,
  }) async {
    isUpdating = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cart = await _repository.addCartItem(
        storeId: storeId,
        productId: productId,
        productType: productType,
        qty: qty,
      );

      _replaceCart(cart);

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> updateQuantity({
    required String itemId,
    required int qty,
  }) async {
    if (qty < 1) return false;

    isUpdating = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cart = await _repository.updateCartItem(
        itemId: itemId,
        qty: qty,
      );

      _replaceCart(cart);

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  Future<bool> removeItem(String itemId) async {
    isUpdating = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cart = await _repository.removeCartItem(itemId);

      _replaceCart(cart);

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  void _replaceCart(CartModel updatedCart) {
    final index = carts.indexWhere(
      (cart) => cart.storeId == updatedCart.storeId,
    );

    if (index == -1) {
      carts.add(updatedCart);
    } else {
      carts[index] = updatedCart;
    }
  }

  int get totalItems {
    return carts.fold(
      0,
      (total, cart) {
        return total +
            cart.items.fold(
              0,
              (sum, item) => sum + item.qty,
            );
      },
    );
  }

  double get totalPrice {
    return carts.fold(
      0,
      (total, cart) {
        return total +
            cart.items.fold(
              0,
              (sum, item) => sum + (item.price * item.qty),
            );
      },
    );
  }
}