import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.stock,
    required super.brand,
    required super.category,
    required super.thumbnail,
    required super.images,
    required super.availabilityStatus,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      stock: json['stock'] ?? 0,
      brand: json['brand'] ?? '',
      category: json['category'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      images: List<String>.from(
        json['images'] ?? [],
      ),
      availabilityStatus:
          json['availabilityStatus'] ?? '',
    );
  }
}