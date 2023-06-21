import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';
import 'package:uuid/uuid.dart';

class VendorBargainConfirmationTab extends StatelessWidget {
  String formatedDate(date) {
    final OutPutDateFormat = DateFormat('dd/MM/yyyy');
    final outPutDate = OutPutDateFormat.format(date);

    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Stream<QuerySnapshot> _bargainStream = FirebaseFirestore.instance
        .collection('bargains')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('confirmed', isEqualTo: false)
        .snapshots();

    Future<void> rejectBargainRequest(String bargainId) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure want to reject this order?'),
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
                    'Bargain Request has been Rejected',
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 60,
                    ),
                  );
                  await _firestore
                      .collection('bargains')
                      .doc(bargainId)
                      .update({
                    'confirmed': true,
                  });
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> acceptBargainRequest(
      String bargainId,
      String vendorId,
      String businessName,
      String email,
      String phone,
      String address,
      String postalCode,
      String buyerId,
      String fullName,
      String buyerPhoto,
      String productName,
      double bargainPrice,
      String productId,
      List<String> productImage,
      String productSize,
    ) async {
      final orderId = Uuid().v4();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure want to accept this bargain request?'),
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
                    'Bargain Request has been accepted',
                    Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 60,
                    ),
                  );
                  await _firestore
                      .collection('bargains')
                      .doc(bargainId)
                      .update({
                    'confirmed': true,
                    'accepted': true,
                  });

                  await _firestore.collection('orders').doc(orderId).set({
                    'orderId': orderId,
                    'vendorId': vendorId,
                    'businessName': businessName,
                    'email': email,
                    'phone': phone,
                    'address': address,
                    'postalCode': postalCode,
                    'buyerId': buyerId,
                    'fullName': fullName,
                    'buyerPhoto': buyerPhoto,
                    'productName': productName,
                    'productPrice': bargainPrice,
                    'productId': productId,
                    'productImage': productImage,
                    'productSize': productSize,
                    'orderDate': DateTime.now(),
                    'accepted': true,
                    'status': 'Waiting For Payment',
                  });

                  await _firestore
                      .collection('products')
                      .doc(productId)
                      .update({
                    'onPayment': true,
                  });
                },
              ),
            ],
          );
        },
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _bargainStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: blackColor),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No Bargain Request',
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
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: Icon(Icons.access_time),
                    ),
                    title: Text(
                      'Waiting Confirmation',
                      style: TextStyle(color: Colors.yellow.shade900),
                    ),
                    trailing: Text(
                      '${NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(document['bargainPrice'])}',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.green,
                      ),
                    ),
                    subtitle: Text(
                      formatedDate(
                        document['bargainRequestDate'].toDate(),
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
                    subtitle: Text('View Bargain Request Details'),
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
                  if (!document['accepted'])
                    SlidableAction(
                      onPressed: (context) async {
                        await rejectBargainRequest(document['bargainId']);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.do_not_disturb_sharp,
                      label: 'Reject',
                    ),
                  SlidableAction(
                    onPressed: (context) async {
                      await acceptBargainRequest(
                        document['bargainId'],
                        document['vendorId'],
                        document['businessName'],
                        document['email'],
                        document['phone'],
                        document['address'],
                        document['postalCode'],
                        document['buyerId'],
                        document['fullName'],
                        document['buyerPhoto'],
                        document['productName'],
                        document['bargainPrice'],
                        document['productId'],
                        List<String>.from(document['productImage']),
                        document['productSize'],
                      );
                    },
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    icon: Icons.check,
                    label: 'Accept',
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
