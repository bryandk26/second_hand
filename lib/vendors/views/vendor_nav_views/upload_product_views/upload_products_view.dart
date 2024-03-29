import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/provider/product_provider.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';
import 'package:second_chance/vendors/views/vendor_main_screen.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/upload_product_views/upload_tab_screens/atrributes_tab_screen.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/upload_product_views/upload_tab_screens/general_tab_screen.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/upload_product_views/upload_tab_screens/images_tab_screen.dart';
import 'package:uuid/uuid.dart';

class UploadProductsView extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveProduct(
      BuildContext context, ProductProvider productProvider) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (productProvider.productData['imageUrlList'] == null ||
        productProvider.productData['imageUrlList'].isEmpty) {
      return displayDialog(
        context,
        'You must upload atleast 1 image',
        Icon(
          Icons.error,
          color: Colors.red,
          size: 60,
        ),
      );
    }

    EasyLoading.show(status: 'On Progress...');
    if (_formKey.currentState!.validate()) {
      final productId = Uuid().v4();

      final vendorSnapshot = await _firestore
          .collection('vendors')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      await _firestore.collection('products').doc(productId).set({
        'productId': productId,
        'productName': productProvider.productData['productName'],
        'productPrice': productProvider.productData['productPrice'],
        'productDescription': productProvider.productData['productDescription'],
        'category': productProvider.productData['category'],
        'imageUrlList': productProvider.productData['imageUrlList'],
        'brandName': productProvider.productData['brandName'],
        'size': productProvider.productData['size'],
        'vendorId': FirebaseAuth.instance.currentUser!.uid,
        'businessName': vendorSnapshot['businessName'],
        'approved': false,
        'sold': false,
        'onPayment': false,
        'viewed': 0,
        'productAddedDate': DateTime.now(),
      }).whenComplete(() {
        productProvider.clearData();
        _formKey.currentState!.reset();
        EasyLoading.dismiss();

        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return VendorMainScreen();
          },
        ));

        displayDialog(
          context,
          'Product has been uploaded successfully',
          Icon(
            Icons.check,
            color: Colors.green,
            size: 60,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProductProvider _product_provider =
        Provider.of<ProductProvider>(context);
    bool _isLoading = false;

    return DefaultTabController(
      length: 3,
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
            bottom: TabBar(
              indicatorColor: blackColor,
              tabs: [
                Tab(
                  child: Text(
                    'General',
                    style: TextStyle(color: blackColor, fontSize: 12),
                  ),
                ),
                Tab(
                  child: Text(
                    'Attributes',
                    style: TextStyle(color: blackColor, fontSize: 12),
                  ),
                ),
                Tab(
                  child: Text(
                    'Images',
                    style: TextStyle(color: blackColor, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              GeneralTabScreen(),
              AttributesTabScreen(),
              ImagesTabScreen(),
            ],
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                _saveProduct(context, _product_provider);
              },
              child: ButtonGlobal(isLoading: _isLoading, text: 'Upload'),
            ),
          ),
        ),
      ),
    );
  }
}
