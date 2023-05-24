import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_order_views/vendor_orders_detail_view.dart';

class VendorOrdersView extends StatelessWidget {
  String formatedDate(date) {
    final OutPutDateFormat = DateFormat('dd/MM/yyyy');
    final outPutDate = OutPutDateFormat.format(date);

    return outPutDate;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateOrderStatus(DocumentSnapshot document) async {
    if (document['accepted'] == true) {
      final status = 'Waiting for Payment';
      final orderId = document['orderId'];

      try {
        await FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .update({'status': status});
      } catch (e) {
        print('Error updating order status: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _orderStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: whiteColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Order Lists',
            style: subTitle,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _orderStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: blackColor),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Slidable(
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return VendorOrderDetailView(
                                    orderData: document);
                              },
                            ));
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            child: document['accepted'] == true
                                ? Icon(Icons.delivery_dining)
                                : Icon(Icons.access_time),
                          ),
                          title: document['accepted'] == true
                              ? Text(
                                  'Accepted',
                                  style: TextStyle(color: Colors.green),
                                )
                              : Text(
                                  'Not Accepted',
                                  style: TextStyle(color: Colors.red),
                                ),
                          trailing: Text(
                            '${NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(document['productPrice'])}',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.green,
                            ),
                          ),
                          subtitle: Text(
                            formatedDate(
                              document['orderDate'].toDate(),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        ExpansionTile(
                          title: Text(
                            'Order Detail',
                            style: TextStyle(
                              color: Colors.yellow.shade900,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text('View Order Details'),
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image.network(
                                  document['productImage'][0],
                                ),
                              ),
                              title: Text(
                                  'Product Name: ' + document['productName']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Buyer Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Name ' + document['fullName']),
                                        Text('Email' + document['email']),
                                        Text('Address' + document['address']),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        if (!document['accepted'])
                          SlidableAction(
                            onPressed: (context) async {
                              await _firestore
                                  .collection('orders')
                                  .doc(document['orderId'])
                                  .update({
                                'accepted': false,
                              });
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.do_not_disturb_sharp,
                            label: 'Reject',
                          ),
                        SlidableAction(
                          onPressed: (context) async {
                            await _firestore
                                .collection('orders')
                                .doc(document['orderId'])
                                .update({
                              'accepted': true,
                            }).whenComplete(() => updateOrderStatus(document));
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.check,
                          label: !document['accepted'] ? 'Accept' : 'Accepted',
                        ),
                      ],
                    ));
              }).toList(),
            );
          },
        ));
  }
}
