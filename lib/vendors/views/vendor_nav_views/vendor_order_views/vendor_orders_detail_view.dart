import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_order_views/input_delivery_order_view.dart';

class VendorOrderDetailView extends StatelessWidget {
  final dynamic orderData;

  const VendorOrderDetailView({Key? key, required this.orderData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;

    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
    );
    final DateFormat dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

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
          'Order Detail',
          style: subTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.network(
                      orderData['productImage'][0],
                    ),
                  ),
                  title: Text(
                    'Product Name: ${orderData['productName']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Order Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Status: ${orderData.data()!.containsKey('status') ? orderData.data()!['status'] : 'Not Accepted'}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: orderData.data()!.containsKey('status')
                        ? Colors.blue
                        : Colors.red,
                  ),
                ),
                Text(
                    'Price: ${currencyFormatter.format(orderData['productPrice'])}'),
                Text(
                    'Order Date: ${dateFormatter.format(orderData['orderDate'].toDate())}'),
                SizedBox(height: 16),
                Text(
                  'Buyer Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('Name: ${orderData['fullName']}'),
                Text('Email: ${orderData['email']}'),
                Text('Address: ${orderData['address']}'),
                SizedBox(height: 16),
                ConditionalBuilder(
                  condition: orderData['accepted'] == true,
                  builder: (context) => Card(
                    color: Colors.grey[200],
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        'Payment Receipt',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: orderData.data()!.containsKey('paymentReceipt')
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PhotoView(
                                      backgroundDecoration:
                                          BoxDecoration(color: whiteColor),
                                      imageProvider: NetworkImage(
                                          orderData['paymentReceipt']),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  orderData['paymentReceipt'],
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'No payment receipt available',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                    ),
                  ),
                  fallback: (context) => Container(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: orderData.data()!.containsKey('status') &&
              orderData['status'] == 'Paid'
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InputDeliveryOrderView(orderData: orderData),
                        ));
                  },
                  child: ButtonGlobal(
                      isLoading: _isLoading, text: 'DELIVER ORDER')),
            )
          : null,
    );
  }
}
