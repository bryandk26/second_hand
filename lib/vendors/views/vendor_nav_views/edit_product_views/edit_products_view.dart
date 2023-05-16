import 'package:flutter/material.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/edit_product_views/edit_product_tab_views/unpublished_tab.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/edit_product_views/edit_product_tab_views/published_tab.dart';

class EditProductsView extends StatelessWidget {
  const EditProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: whiteColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Manage Product',
            style: subTitle,
          ),
          bottom: TabBar(indicatorColor: blackColor, tabs: [
            Tab(
              child: Text(
                'Published',
                style: TextStyle(color: blackColor, fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                'Unpublished',
                style: TextStyle(color: blackColor, fontSize: 12),
              ),
            ),
          ]),
        ),
        body: TabBarView(children: [
          PublishedTab(),
          UnpublishedTab(),
        ]),
      ),
    );
  }
}
