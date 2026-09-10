import 'package:flutter/material.dart';

import '../repositories/order_summary_repository.dart';

class OrderSummaryProvider extends ChangeNotifier {
  final OrderSummaryRepository _repository;

  OrderSummaryProvider({OrderSummaryRepository? repository})
    : _repository = repository ?? OrderSummaryRepository();

  bool isLoading = false;
  String? errorMessage;

  Map<String, dynamic> summary = {};

  Future<void> loadSummary({required String storeId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      summary = await _repository.getOrderSummary(storeId: storeId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  double get subtotal {
    return _toDouble(summary['subtotal'] ?? summary['subTotal']);
  }

  double get deliveryFee {
    return _toDouble(summary['deliveryFee'] ?? summary['deliveryCharge']);
  }

  double get tax {
    return _toDouble(summary['tax'] ?? summary['taxAmount']);
  }

  double get discount {
    return _toDouble(summary['discount'] ?? summary['discountAmount']);
  }

  double get total {
    return _toDouble(
      summary['total'] ?? summary['grandTotal'] ?? summary['totalAmount'],
    );
  }

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
