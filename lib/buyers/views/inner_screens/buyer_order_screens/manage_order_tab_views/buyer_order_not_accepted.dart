import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_order_screens/buyer_order_detail_screen.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';

class BuyerOrderNotAcceptedTab extends StatelessWidget {
  String formatedDate(date) {
    final OutPutDateFormat = DateFormat('dd/MM/yyyy');
    final outPutDate = OutPutDateFormat.format(date);

    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _orderStream = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('accepted', isEqualTo: false)
        .snapshots();

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> cancelOrder(String orderId, String productId) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure want to cancel this order?'),
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
                    'Your order has been canceled',
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 60,
                    ),
                  );
                  await _firestore.collection('orders').doc(orderId).update({
                    'status': 'Canceled',
                  });
                  await _firestore.collection('orders').doc(orderId).update({
                    'accepted': true,
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
              'No Order Made',
              style: subTitle,
            ),
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
                          return BuyerOrderDetailScreen(orderData: document);
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
                        title: Text('Product Name: ' + document['productName']),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                      await cancelOrder(
                        document['orderId'],
                        document['productId'],
                      );
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.do_not_disturb_sharp,
                    label: 'Cancel',
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
