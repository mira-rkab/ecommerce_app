

class ProductModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String? image;
  final String? createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    this.image,
    this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      category: json['category']?.toString() ?? '',
      image: json['image']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }
}
