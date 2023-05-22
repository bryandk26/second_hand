import 'package:flutter/widgets.dart';

class CartAttributes with ChangeNotifier {
  final String productName;
  final String productId;
  final List imageUrl;
  final double price;
  final String vendorId;
  final String productSize;
  final String businessName;

  CartAttributes({
    required this.productName,
    required this.productId,
    required this.imageUrl,
    required this.price,
    required this.vendorId,
    required this.productSize,
    required this.businessName,
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productId': productId,
      'imageUrl': imageUrl,
      'price': price,
      'vendorId': vendorId,
      'productSize': productSize,
      'businessName': businessName,
    };
  }
}
