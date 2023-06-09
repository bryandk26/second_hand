import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:second_chance/buyers/cart_attributes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttributes> _cartItems = {};

  Map<String, CartAttributes> get getCartItem {
    return _cartItems;
  }

  double get totalPrice {
    var total = 0.00;

    _cartItems.forEach((key, value) {
      total += value.price;
    });

    return total;
  }

  Future<void> saveCartData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartData = _cartItems.values.map((cart) => cart.toJson()).toList();
      final encodedData = jsonEncode(cartData);
      await prefs.setString('cartData', encodedData);
    } catch (error) {
      throw Exception('Failed to save cart data: $error');
    }
  }

  Future<void> loadCartData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedData = prefs.getString('cartData');
      if (encodedData != null) {
        final cartData = jsonDecode(encodedData) as List<dynamic>;
        final items = cartData
            .map((item) => CartAttributes(
                  productName: item['productName'],
                  productId: item['productId'],
                  imageUrl: List<String>.from(item['imageUrl']),
                  price: item['price'],
                  vendorId: item['vendorId'],
                  productSize: item['productSize'],
                  businessName: item['businessName'],
                ))
            .toList();
        _cartItems = Map.fromIterable(
          items,
          key: (item) => item.productId,
          value: (item) => item,
        );
      }
    } catch (error) {
      throw Exception('Failed to load cart data: $error');
    }
  }

  void addProductToCart(
    String productName,
    String productId,
    List imageUrl,
    double price,
    String vendorId,
    String productSize,
    String businessName,
  ) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (existingCart) => CartAttributes(
                productName: existingCart.productName,
                productId: existingCart.productId,
                imageUrl: existingCart.imageUrl,
                price: existingCart.price,
                vendorId: existingCart.vendorId,
                productSize: existingCart.productSize,
                businessName: existingCart.businessName,
              ));

      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartAttributes(
                productName: productName,
                productId: productId,
                imageUrl: imageUrl,
                price: price,
                vendorId: vendorId,
                productSize: productSize,
                businessName: businessName,
              ));

      notifyListeners();
    }
    saveCartData();
  }

  removeItem(productId) {
    _cartItems.remove(productId);

    notifyListeners();

    saveCartData();
  }

  removeAllCartItem() {
    _cartItems.clear();

    notifyListeners();

    saveCartData();
  }
}
