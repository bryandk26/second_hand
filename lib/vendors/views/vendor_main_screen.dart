import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/edit_product_views/edit_products_view.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/upload_product_views/upload_products_view.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_account_views/vendor_account_view.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_bargain_requests_view.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_order_views/vendor_orders_view.dart';

class VendorMainScreen extends StatefulWidget {
  final int initialIndex;
  const VendorMainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
  int _pageIndex = 0;

  List<Widget> _pages = [
    VendorBargainRequestsView(),
    UploadProductsView(),
    EditProductsView(),
    VendorOrdersView(),
    VendorAccountView()
  ];

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: blackColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GNav(
                backgroundColor: blackColor,
                color: whiteColor,
                activeColor: whiteColor,
                tabBackgroundColor: darkGrey,
                gap: 8,
                padding: EdgeInsets.all(8),
                selectedIndex: _pageIndex,
                onTabChange: (value) {
                  setState(() {
                    _pageIndex = value;
                  });
                },
                tabs: [
                  GButton(
                    icon: CupertinoIcons.money_dollar_circle,
                    text: 'BARGAIN',
                  ),
                  GButton(
                    icon: CupertinoIcons.cloud_upload,
                    text: 'UPLOAD',
                  ),
                  GButton(
                    icon: CupertinoIcons.pencil,
                    text: 'EDIT',
                  ),
                  GButton(
                    icon: CupertinoIcons.cart,
                    text: 'ORDERS',
                  ),
                  GButton(
                    icon: CupertinoIcons.person,
                    text: 'ACCOUNT',
                  ),
                ]),
          ),
        ),
        body: _pages[_pageIndex],
      ),
    );
  }
}
