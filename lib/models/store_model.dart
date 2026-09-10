class StoreModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? address;
  final double? distance;

  StoreModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.address,
    this.distance,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      address: json['address']?.toString(),
      distance: _parseDouble(json['distanceKm']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}