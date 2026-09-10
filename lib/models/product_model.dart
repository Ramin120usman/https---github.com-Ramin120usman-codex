class ProductModel {
  final String id;
  final String name;
  final String? imageUrl;
  final double? price;
  final bool isFavorited;
  final String? storeId;
  final String? productType;
  final String? storeName;
  final bool inStock;
  final String? offerLabel;

  ProductModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.price,
    this.isFavorited = false,
    this.storeId,
    this.productType,
    this.storeName,
    this.inStock = true,
    this.offerLabel,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double? price;

    final pricing = json['pricing'];

    if (pricing is Map) {
      final pricingMap = Map<String, dynamic>.from(pricing);

      final value = pricingMap['price'] ??
          pricingMap['sellingPrice'] ??
          pricingMap['effectivePrice'];

      if (value is num) {
        price = value.toDouble();
      } else if (value != null) {
        price = double.tryParse(value.toString());
      }
    }

    String? offerLabel;

    final offer = json['offer'];

    if (offer is Map) {
      offerLabel = offer['label']?.toString();
    }

    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      price: price,
      isFavorited: json['isFavorited'] == true,
      storeId: json['storeId']?.toString(),
      productType: json['type']?.toString(),
      storeName: json['storeName']?.toString(),
      inStock: json['inStock'] != false,
      offerLabel: offerLabel,
    );
  }
}