import 'package:flutter/widgets.dart';
import 'package:second_chance/buyers/models/cart_attributes.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};

  Map<String, CartAttr> get getCartItem {
    return _cartItems;
  }

  double get totalPrice {
    var total = 0.00;

    _cartItems.forEach((key, value) {
      total += value.price;
    });

    return total;
  }

  void addProductToCart(
    String productName,
    String productId,
    List imageUrl,
    double price,
    String vendorId,
    String productSize,
  ) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (existingCart) => CartAttr(
                productName: existingCart.productName,
                productId: existingCart.productId,
                imageUrl: existingCart.imageUrl,
                price: existingCart.price,
                vendorId: existingCart.vendorId,
                productSize: existingCart.productSize,
              ));

      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartAttr(
                productName: productName,
                productId: productId,
                imageUrl: imageUrl,
                price: price,
                vendorId: vendorId,
                productSize: productSize,
              ));

      notifyListeners();
    }
  }

  removeItem(productId) {
    _cartItems.remove(productId);

    notifyListeners();
  }

  removeAllItem() {
    _cartItems.clear();

    notifyListeners();
  }
}
