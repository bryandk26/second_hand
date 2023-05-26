import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_bargain_screens/buyer_bargain_tabs/buyer_bargain_accepted_tab_screen.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_bargain_screens/buyer_bargain_tabs/buyer_bargain_confirmation_tab_screen.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_bargain_screens/buyer_bargain_tabs/buyer_bargain_rejected_tab_screen.dart';
import 'package:second_chance/theme.dart';

class BuyerBargainRequestsScreen extends StatelessWidget {
  const BuyerBargainRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
            'My Bargain Requests',
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
          BuyerBargainConfirmationTab(),
          BuyerBargainAcceptedTab(),
          BuyerBargainRejectedTab(),
        ]),
      ),
    );
  }
}
