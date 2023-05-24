import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_order_screens/manage_order_tab_views/buyer_order_canceled.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_order_screens/manage_order_tab_views/buyer_order_done.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_order_screens/manage_order_tab_views/buyer_order_not_accepted.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_order_screens/manage_order_tab_views/buyer_order_on_delivery.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_order_screens/manage_order_tab_views/buyer_order_paid.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_order_screens/manage_order_tab_views/buyer_order_request_warranty.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_order_screens/manage_order_tab_views/buyer_order_waiting_for_payment.dart';
import 'package:second_chance/theme.dart';

class BuyerOrderTabView extends StatelessWidget {
  const BuyerOrderTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(color: blackColor),
          title: Text(
            'My Orders',
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
          BuyerOrderNotAcceptedTab(),
          BuyerOrderWaitingPaymentTab(),
          BuyerOrderPaidTab(),
          BuyerOrderOnDeliveryTab(),
          BuyerOrderDoneTab(),
          BuyerOrderCanceledTab(),
          BuyerOrderWarrantyTab(),
        ]),
      ),
    );
  }
}
