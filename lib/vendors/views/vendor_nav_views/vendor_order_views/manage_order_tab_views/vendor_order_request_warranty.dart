import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_order_views/manage_order_tab_views/vendor_request_warranty_order_view/vendor_request_warranty_detail_view.dart';

class VendorOrderWarrantyTab extends StatelessWidget {
  String formatedDate(date) {
    final OutPutDateFormat = DateFormat('dd/MM/yyyy');
    final outPutDate = OutPutDateFormat.format(date);

    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _orderStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', whereIn: [
      'Request Warranty',
      'Waiting Delivery',
      'Waiting Vendor Payment',
      'Warranty Taken',
    ]).snapshots();

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> rejectWarrantyRequest(String orderId) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure want to reject this warranty request?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  displayDialog(
                    context,
                    'Warranty has been rejected',
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 60,
                    ),
                  );
                  await _firestore.collection('orders').doc(orderId).update({
                    'status': 'Rejected',
                  });
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> acceptWarrantyRequest(String orderId) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure want to accept this warranty request?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  displayDialog(
                    context,
                    'Warranty request has been accepted',
                    Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 60,
                    ),
                  );
                  await _firestore.collection('orders').doc(orderId).update({
                    'status': 'Waiting Delivery',
                  });
                },
              ),
            ],
          );
        },
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _orderStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: blackColor),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No Request Order Warranty',
              style: subTitle,
            ),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return document['status'] == 'Request Warranty'
                ? Slidable(
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return VendorRequestWarrantyDetailView(
                                    orderData: document);
                              },
                            ));
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 14,
                            child: Icon(
                              Icons.change_circle,
                              color: Colors.yellow.shade900,
                            ),
                          ),
                          title: Text(
                            '${document['status']}',
                            style: TextStyle(color: Colors.yellow.shade900),
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
                                        Text('Name: ' + document['fullName']),
                                        Text('Email: ' + document['email']),
                                        Text('Address: ' + document['address']),
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
                        SlidableAction(
                          onPressed: (context) async {
                            await rejectWarrantyRequest(document['orderId']);
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.do_not_disturb_sharp,
                          label: 'Reject',
                        ),
                        SlidableAction(
                          onPressed: (context) async {
                            await acceptWarrantyRequest(document['orderId']);
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.check,
                          label: 'Accept',
                        ),
                      ],
                    ))
                : Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return VendorRequestWarrantyDetailView(
                                  orderData: document);
                            },
                          ));
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 14,
                          child: Icon(
                            Icons.change_circle,
                            color: document['status'] == 'Warranty Taken'
                                ? Colors.green
                                : Colors.yellow.shade900,
                          ),
                        ),
                        title: Text(
                          '${document['status']}',
                          style: TextStyle(
                            color: document['status'] == 'Warranty Taken'
                                ? Colors.green
                                : Colors.yellow.shade900,
                          ),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Name: ' + document['fullName']),
                                      Text('Email: ' + document['email']),
                                      Text('Address: ' + document['address']),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  );
          }).toList(),
        );
      },
    );
  }
}
