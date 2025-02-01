import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../orders/order_model.dart' as custom_order;

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      String? sellerId = _auth.currentUser?.uid;
      if (sellerId == null) {
        throw 'User not authenticated';
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .where('sellerId', isEqualTo: sellerId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      throw 'Failed to fetch products: $e';
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      String? sellerId = _auth.currentUser?.uid;
      if (sellerId == null) {
        throw 'User not authenticated';
      }

      // Verify that the product belongs to the current seller
      DocumentSnapshot productDoc = await _firestore.collection('products').doc(productId).get();
      if (productDoc.exists && productDoc.get('sellerId') == sellerId) {
        await _firestore.collection('products').doc(productId).delete();
      } else {
        throw 'You do not have permission to delete this product';
      }
    } catch (e) {
      throw 'Failed to delete product: $e';
    }
  }

  Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required double originalPrice,
    required double discountPercentage,
    required int stockQuantity,
    required String category,
    String? imageBase64,
    required String brand,
    required bool isLimitedTimeDeal,
    required bool isEligibleForFreeShipping,
    String? deliveryETA,
  }) async {
    try {
      String? sellerId = _auth.currentUser?.uid;
      if (sellerId == null) {
        throw 'User not authenticated';
      }

      await _firestore.collection('products').add({
        'productName': name,
        'description': description,
        'price': price,
        'originalPrice': originalPrice,
        'discountPercentage': discountPercentage,
        'stockQuantity': stockQuantity,
        'category': category,
        'imageBase64': imageBase64,
        'brand': brand,
        'isLimitedTimeDeal': isLimitedTimeDeal,
        'isEligibleForFreeShipping': isEligibleForFreeShipping,
        'deliveryETA': deliveryETA,
        'sellerId': sellerId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to add product: $e';
    }
  }

  Future<List<custom_order.Order>> getSellerOrders() async {
    try {
      String? sellerId = _auth.currentUser?.uid;
      if (sellerId == null) {
        throw 'User not authenticated';
      }

      QuerySnapshot ordersSnapshot = await _firestore
          .collection('orders')
          .get();

      List<custom_order.Order> orders = [];
      for (var doc in ordersSnapshot.docs) {
        try {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          if (data['products'] == null) continue;

          List<dynamic> productsList = data['products'] as List<dynamic>;
          
          // Filter items for current seller
          List<custom_order.OrderItem> sellerItems = [];
          for (var product in productsList) {
            if (product is Map<String, dynamic> && product['sellerId'] == sellerId) {
              sellerItems.add(custom_order.OrderItem.fromMap({
                'productId': product['productId'] ?? '',
                'productName': product['productName'] ?? '',
                'imageBase64': product['imageBase64'],
                'price': product['price'] ?? 0.0,
                'quantity': product['quantity'] ?? 0,
                'sellerId': product['sellerId'] ?? '',
              }));
            }
          }

          // Only include orders that have products from this seller
          if (sellerItems.isNotEmpty) {
            orders.add(custom_order.Order.fromMap(data, doc.id, sellerItems));
          }
        } catch (e) {
          print('Error processing order document: $e');
          continue;
        }
      }

      // Sort orders by date, most recent first
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      
      return orders;
    } catch (e) {
      throw 'Failed to fetch orders: $e'; 
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      String? sellerId = _auth.currentUser?.uid;
      if (sellerId == null) {
        throw 'User not authenticated';
      }

      await _firestore.collection('orders').doc(orderId).update({
        'currentStatus': newStatus,
        'trackingInfo': {
          'status': newStatus,
          'updatedAt': FieldValue.serverTimestamp(),
          'updatedBy': sellerId,
        },
      });
    } catch (e) {
      throw 'Failed to update order status: $e';
    }
  }
}