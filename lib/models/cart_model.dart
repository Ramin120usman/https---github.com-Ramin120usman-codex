class CartItemModel {
  final String id;
  final String storeId;
  final String productId;
  final String productType;
  final int qty;

  final String name;
  final String? imageUrl;
  final double price;

  CartItemModel({
    required this.id,
    required this.storeId,
    required this.productId,
    required this.productType,
    required this.qty,
    required this.name,
    this.imageUrl,
    required this.price,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] is Map
        ? Map<String, dynamic>.from(json['product'])
        : <String, dynamic>{};

    final pricing = product['pricing'] is Map
        ? Map<String, dynamic>.from(product['pricing'])
        : <String, dynamic>{};

    return CartItemModel(
      id: json['id']?.toString() ?? '',
      storeId: json['storeId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      productType: json['productType']?.toString() ?? '',
      qty: _toInt(json['qty'] ?? json['quantity']),

      name: json['name']?.toString() ??
          product['name']?.toString() ??
          'Product',

      imageUrl: json['imageUrl']?.toString() ??
          product['imageUrl']?.toString(),

      price: _toDouble(
        json['price'] ??
            product['price'] ??
            pricing['sellingPrice'] ??
            pricing['effectivePrice'],
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}

class CartModel {
  final String storeId;
  final List<CartItemModel> items;

  CartModel({
    required this.storeId,
    required this.items,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    return CartModel(
      storeId: json['storeId']?.toString() ?? '',
      items: rawItems is List
          ? rawItems
              .whereType<Map>()
              .map(
                (item) => CartItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
    );
  }
}