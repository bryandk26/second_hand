import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/buyers/views/nav_screens/account_screen.dart';
import 'package:second_chance/buyers/views/nav_screens/cart_screen.dart';
import 'package:second_chance/buyers/views/nav_screens/categories_screen.dart';
import 'package:second_chance/buyers/views/nav_screens/home_screen.dart';
import 'package:second_chance/buyers/views/nav_screens/products_screen.dart';
import 'package:second_chance/buyers/views/nav_screens/store_screen.dart';
import 'package:second_chance/provider/cart_provider.dart';
import 'package:second_chance/theme.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  List<Widget> _pages = [
    HomeScreen(),
    CategoriesScreen(),
    ProductsScreen(),
    StoreScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageIndex = widget.initialIndex;
    Provider.of<CartProvider>(context, listen: false).loadCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  icon: CupertinoIcons.home,
                  text: 'HOME',
                ),
                GButton(
                  icon: CupertinoIcons.collections,
                  text: 'CATEGORIES',
                ),
                GButton(
                  icon: CupertinoIcons.square_grid_2x2,
                  text: 'PRODUCTS',
                ),
                GButton(
                  icon: CupertinoIcons.bag,
                  text: 'STORE',
                ),
                GButton(
                  icon: CupertinoIcons.cart,
                  text: 'CART',
                ),
                GButton(
                  icon: CupertinoIcons.person,
                  text: 'ACCOUNT',
                ),
              ]),
        ),
      ),
      body: _pages[_pageIndex],
    );
  }
}
