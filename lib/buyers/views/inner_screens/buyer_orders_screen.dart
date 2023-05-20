import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:second_chance/theme.dart';

class BuyerOrdersScreen extends StatelessWidget {
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
        .snapshots();

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
            'My Orders',
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
                child: CircularProgressIndicator(color: Colors.yellow.shade900),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                return Column(
                  children: [
                    ListTile(
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  'Product Details',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Name: ' + document['productName']),
                                    Text('Price: '
                                        '${NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(document['productPrice'])}'),
                                    Text('Size: ' + document['productSize']),
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
        ));
  }
}
