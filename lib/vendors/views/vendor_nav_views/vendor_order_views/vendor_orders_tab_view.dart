import 'package:flutter/material.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_order_views/manage_order_tab_views/vendor_order_canceled.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_order_views/manage_order_tab_views/vendor_order_done.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_order_views/manage_order_tab_views/vendor_order_not_accepted.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_order_views/manage_order_tab_views/vendor_order_on_delivery.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_order_views/manage_order_tab_views/vendor_order_paid.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_order_views/manage_order_tab_views/vendor_order_request_warranty.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_order_views/manage_order_tab_views/vendor_order_waiting_for_payment.dart';

class VendorOrderTabView extends StatelessWidget {
  const VendorOrderTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: whiteColor,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Manage Orders',
            style: subTitle,
          ),
          bottom: TabBar(isScrollable: true, indicatorColor: blackColor, tabs: [
            Tab(
              child: Text(
                'Not Accepted',
                style: TextStyle(color: blackColor, fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                'Waiting Payment',
                style: TextStyle(color: blackColor, fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                'Paid',
                style: TextStyle(color: blackColor, fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                'On Delivery',
                style: TextStyle(color: blackColor, fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                'Done',
                style: TextStyle(color: blackColor, fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                'Canceled',
                style: TextStyle(color: blackColor, fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                'Warranty Request',
                style: TextStyle(color: blackColor, fontSize: 12),
              ),
            ),
          ]),
        ),
        body: TabBarView(children: [
          VendorOrderNotAcceptedTab(),
          VendorOrderWaitingPaymentTab(),
          VendorOrderPaidTab(),
          VendorOrderOnDeliveryTab(),
          VendorOrderDoneTab(),
          VendorOrderCanceledTab(),
          VendorOrderWarrantyTab(),
        ]),
      ),
    );
  }
}
