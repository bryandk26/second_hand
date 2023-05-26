import 'package:flutter/material.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_bargain_views/vendor_bargain_tabs/vendor_bargain_accepted_tab_screen.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_bargain_views/vendor_bargain_tabs/vendor_bargain_confirmation_tab_screen.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_bargain_views/vendor_bargain_tabs/vendor_bargain_rejected_tab_screen.dart';

class VendorBargainRequestsView extends StatelessWidget {
  const VendorBargainRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: whiteColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Bargain Requests',
            style: subTitle,
          ),
          bottom: TabBar(indicatorColor: blackColor, tabs: [
            Tab(
              child: Text(
                'Waiting Confirmation',
                style: TextStyle(color: blackColor, fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                'Accepted',
                style: TextStyle(color: blackColor, fontSize: 12),
              ),
            ),
            Tab(
              child: Text(
                'Rejected',
                style: TextStyle(color: blackColor, fontSize: 12),
              ),
            ),
          ]),
        ),
        body: TabBarView(children: [
          VendorBargainConfirmationTab(),
          VendorBargainAcceptedTab(),
          VendorBargainRejectedTab(),
        ]),
      ),
    );
  }
}
