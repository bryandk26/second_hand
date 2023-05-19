import 'package:flutter/widgets.dart';

class CartAttr with ChangeNotifier {
  final String productName;
  final String productId;
  final List imageUrl;
  final double price;
  final String vendorId;
  final String productSize;

  CartAttr({
    required this.productName,
    required this.productId,
    required this.imageUrl,
    required this.price,
    required this.vendorId,
    required this.productSize,
  });
}
