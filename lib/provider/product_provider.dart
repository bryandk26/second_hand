import 'package:flutter/widgets.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};

  saveFormData({
    String? productName,
    double? productPrice,
    String? category,
    String? productDescription,
    List<String>? imageUrlList,
    String? brandName,
    String? size,
  }) {
    if (productName != null) {
      productData['productName'] = productName;
    }
    if (productPrice != null) {
      productData['productPrice'] = productPrice;
    }
    if (category != null) {
      productData['category'] = category;
    }
    if (productDescription != null) {
      productData['productDescription'] = productDescription;
    }
    if (imageUrlList != null) {
      productData['imageUrlList'] = imageUrlList;
    }
    if (brandName != null) {
      productData['brandName'] = brandName;
    }
    if (size != null) {
      productData['size'] = size;
    }

    notifyListeners();
  }

  clearData() {
    productData.clear();

    notifyListeners();
  }

  void removeImageUrl(String imageUrl) {
    if (productData['imageUrlList'] != null &&
        productData['imageUrlList'].contains(imageUrl)) {
      productData['imageUrlList'].remove(imageUrl);
    }
  }
}
