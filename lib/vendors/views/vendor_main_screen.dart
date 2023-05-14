import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/earnings_view.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/edit_products_view.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/upload_product_views/upload_products_view.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_account_views/vendor_account_view.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_orders_view.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({super.key});

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
  int _pageIndex = 0;

  List<Widget> _pages = [
    EarningsView(),
    UploadProductsView(),
    EditProductsView(),
    VendorOrdersView(),
    VendorAccountView()
  ];

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
                    icon: CupertinoIcons.money_dollar,
                    text: 'EARNINGS',
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
