import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/provider/product_provider.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/views/vendor_main_screen.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/upload_product_views/upload_tab_screens/atrributes_tab_screen.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/upload_product_views/upload_tab_screens/general_tab_screen.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/upload_product_views/upload_tab_screens/images_tab_screen.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/upload_product_views/upload_tab_screens/shipping_tab_screen.dart';
import 'package:uuid/uuid.dart';

class UploadProductsView extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveProduct(
      BuildContext context, ProductProvider productProvider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    EasyLoading.show(status: 'On Progress...');
    if (_formKey.currentState!.validate()) {
      final productId = Uuid().v4();
      await _firestore.collection('products').doc(productId).set({
        'productId': productId,
        'productName': productProvider.productData['productName'],
        'productPrice': productProvider.productData['productPrice'],
        'quantity': productProvider.productData['quantity'],
        'productDescription': productProvider.productData['productDescription'],
        'category': productProvider.productData['category'],
        'scheduleDate': productProvider.productData['scheduleDate'],
        'imageUrlList': productProvider.productData['imageUrlList'],
        'chargeShipping': productProvider.productData['chargeShipping'],
        'shippingCharge': productProvider.productData['shippingCharge'],
        'brandName': productProvider.productData['brandName'],
        'sizeList': productProvider.productData['sizeList'],
        'vendorId': FirebaseAuth.instance.currentUser!.uid,
        'approved': false,
      }).whenComplete(() {
        productProvider.clearData();
        _formKey.currentState!.reset();
        EasyLoading.dismiss();

        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return VendorMainScreen();
          },
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProductProvider _product_provider =
        Provider.of<ProductProvider>(context);

    return DefaultTabController(
      length: 4,
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: whiteColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Upload Products',
              style: subTitle,
            ),
            // elevation: 1, buat ngatur shadow dibawah appBar
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'General',
                    style: TextStyle(color: blackColor),
                  ),
                ),
                Tab(
                  child: Text(
                    'Shipping',
                    style: TextStyle(color: blackColor),
                  ),
                ),
                Tab(
                  child: Text(
                    'Attributes',
                    style: TextStyle(color: blackColor),
                  ),
                ),
                Tab(
                  child: Text(
                    'Images',
                    style: TextStyle(color: blackColor),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              GeneralTabScreen(),
              ShippingTabScreen(),
              AttributesTabScreen(),
              ImagesTabScreen(),
            ],
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: blackColor),
              onPressed: () {
                _saveProduct(context, _product_provider);
              },
              child: Text('Save'),
            ),
          ),
        ),
      ),
    );
  }
}
