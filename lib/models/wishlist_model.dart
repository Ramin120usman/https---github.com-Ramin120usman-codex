class WishlistItemModel {
  final String id;
  final String productId;
  final String? storeId;
  final String name;
  final String? imageUrl;
  final double price;

  WishlistItemModel({
    required this.id,
    required this.productId,
    this.storeId,
    required this.name,
    this.imageUrl,
    required this.price,
  });

  factory WishlistItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final product = json['product'] is Map
        ? Map<String, dynamic>.from(json['product'])
        : <String, dynamic>{};

    final pricing = product['pricing'] is Map
        ? Map<String, dynamic>.from(product['pricing'])
        : <String, dynamic>{};

    final priceValue = json['price'] ??
        product['price'] ??
        pricing['sellingPrice'] ??
        pricing['effectivePrice'];

    return WishlistItemModel(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ??
          product['id']?.toString() ??
          '',
      storeId: json['storeId']?.toString(),
      name: json['name']?.toString() ??
          product['name']?.toString() ??
          'Product',
      imageUrl: json['imageUrl']?.toString() ??
          product['imageUrl']?.toString(),
      price: _toDouble(priceValue),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0.0;
  }
}