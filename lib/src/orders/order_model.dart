import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String productName;
  final String? imageBase64;
  final double price;
  final int quantity;
  final String sellerId;

  OrderItem({
    required this.productId,
    required this.productName,
    this.imageBase64,
    required this.price,
    required this.quantity,
    required this.sellerId,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      imageBase64: map['imageBase64'],
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 0,
      sellerId: map['sellerId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'imageBase64': imageBase64,
      'price': price,
      'quantity': quantity,
      'sellerId': sellerId,
    };
  }
}

class Order {
  final String id;
  final String buyerId;
  final String buyerName;
  final String buyerAddress;
  final String buyerContact;
  final List<OrderItem> items;
  final double orderTotal;
  final DateTime orderDate;
  final String currentStatus;
  final DateTime deliveryETA;
  final Map<String, dynamic>? trackingInfo;

  Order({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.buyerAddress,
    required this.buyerContact,
    required this.items,
    required this.orderTotal,
    required this.orderDate,
    required this.currentStatus,
    required this.deliveryETA,
    this.trackingInfo,
  });

  factory Order.fromMap(Map<String, dynamic> map, String orderId, List<OrderItem> sellerItems) {
    final Timestamp? orderDateTimestamp = map['orderDate'] as Timestamp?;
    final Timestamp? deliveryETATimestamp = map['deliveryETA'] as Timestamp?;
    
    return Order(
      id: orderId,
      buyerId: map['buyerId'] ?? '',
      buyerName: map['buyerName'] ?? '',
      buyerAddress: map['buyerAddress'] ?? '',
      buyerContact: map['buyerContact'] ?? '',
      items: sellerItems,
      orderTotal: (map['orderTotal'] ?? 0.0).toDouble(),
      orderDate: orderDateTimestamp?.toDate() ?? DateTime.now(),
      currentStatus: map['currentStatus'] ?? 'Ordered',
      deliveryETA: deliveryETATimestamp?.toDate() ?? DateTime.now().add(const Duration(days: 7)),
      trackingInfo: map['trackingInfo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buyerId': buyerId,
      'buyerName': buyerName,
      'buyerAddress': buyerAddress,
      'buyerContact': buyerContact,
      'items': items.map((item) => item.toMap()).toList(),
      'orderTotal': orderTotal,
      'orderDate': Timestamp.fromDate(orderDate),
      'currentStatus': currentStatus,
      'deliveryETA': Timestamp.fromDate(deliveryETA),
      'trackingInfo': trackingInfo,
    };
  }
}