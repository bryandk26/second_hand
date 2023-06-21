import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/buyers/views/inner_screens/edit_profile_screen.dart';
import 'package:second_chance/buyers/views/main_screen.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/provider/cart_provider.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late CartProvider _cartProvider;
  CollectionReference users = FirebaseFirestore.instance.collection('buyers');

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
  }

  Future<void> submitOrderRequest() async {
    EasyLoading.show(status: 'Placing Order');

    final userSnapshot =
        await users.doc(FirebaseAuth.instance.currentUser!.uid).get();
    final userData = userSnapshot.data() as Map<String, dynamic>;

    for (final cartItem in _cartProvider.getCartItem.values) {
      final orderId = Uuid().v4();

      await _firestore.collection('orders').doc(orderId).set({
        'orderId': orderId,
        'vendorId': cartItem.vendorId,
        'businessName': cartItem.businessName,
        'email': userData['email'],
        'phone': userData['phoneNumber'],
        'address': userData['address'],
        'postalCode': userData['postalCode'],
        'buyerId': userData['buyerId'],
        'fullName': userData['fullName'],
        'buyerPhoto': userData['profileImage'],
        'productName': cartItem.productName,
        'productPrice': cartItem.price,
        'productId': cartItem.productId,
        'productImage': cartItem.imageUrl,
        'productSize': cartItem.productSize,
        'orderDate': DateTime.now(),
        'accepted': false,
      });
    }

    setState(() {
      _cartProvider.getCartItem.clear();
    });

    EasyLoading.dismiss();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return MainScreen();
    }));

    Provider.of<CartProvider>(context, listen: false).removeAllCartItem();

    displayDialog(
      context,
      'Your order has been created',
      Icon(
        Icons.check,
        color: Colors.green,
        size: 60,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
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
                'Checkout',
                style: subTitle,
              ),
            ),
            body: Column(
              children: [
                if (data['address'] != '' && data['postalCode'] != '')
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shipping Information',
                              style: subTitle,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EditProfileScreen(userData: data);
                                }));
                              },
                              child: Icon(CupertinoIcons.pencil),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Name: ${data['fullName']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Phone: ${data['phoneNumber']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Address: ${data['address']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Postal Code: ${data['postalCode']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _cartProvider.getCartItem.length,
                  itemBuilder: (context, index) {
                    final cartData =
                        _cartProvider.getCartItem.values.toList()[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                            child: Image.network(
                              cartData.imageUrl[0],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartData.productName,
                                  style: titleText,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(cartData.price)}',
                                  style: subTitle.apply(color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              ],
            ),
            bottomSheet: data['address'] == '' || data['postalCode'] == ''
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditProfileScreen(userData: data);
                        })).whenComplete(() {
                          Navigator.pop(context);
                        });
                      },
                      child: ButtonGlobal(
                        isLoading: _isLoading,
                        text: 'Enter Billing Address',
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: submitOrderRequest,
                      child: ButtonGlobal(
                        isLoading: _isLoading,
                        text: 'PLACE ORDER',
                      ),
                    ),
                  ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.yellow.shade900,
          ),
        );
      },
    );
  }
}
