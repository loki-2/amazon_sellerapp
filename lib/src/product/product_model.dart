class Product {
  final String id;
  final String productName;
  final String description;
  final double price;
  final double originalPrice;
  final double discountPercentage;
  final int stockQuantity;
  final String category;
  final String brand;
  final String? imageBase64;
  final bool isLimitedTimeDeal;
  final bool isEligibleForFreeShipping;
  final String? deliveryETA;

  Product({
    required this.id,
    required this.productName,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.discountPercentage,
    required this.stockQuantity,
    required this.category,
    required this.brand,
    this.imageBase64,
    required this.isLimitedTimeDeal,
    required this.isEligibleForFreeShipping,
    this.deliveryETA,
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      productName: map['productName'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      originalPrice: (map['originalPrice'] ?? 0.0).toDouble(),
      discountPercentage: (map['discountPercentage'] ?? 0.0).toDouble(),
      stockQuantity: map['stockQuantity'] ?? 0,
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
      imageBase64: map['imageBase64'],
      isLimitedTimeDeal: map['isLimitedTimeDeal'] ?? false,
      isEligibleForFreeShipping: map['isEligibleForFreeShipping'] ?? false,
      deliveryETA: map['deliveryETA'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'stockQuantity': stockQuantity,
      'category': category,
      'brand': brand,
      'imageBase64': imageBase64,
      'isLimitedTimeDeal': isLimitedTimeDeal,
      'isEligibleForFreeShipping': isEligibleForFreeShipping,
      'deliveryETA': deliveryETA,
    };
  }
}