import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:second_chance/theme.dart';

class BuyerBargainAcceptedTab extends StatelessWidget {
  String formatedDate(date) {
    final OutPutDateFormat = DateFormat('dd/MM/yyyy');
    final outPutDate = OutPutDateFormat.format(date);

    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _bargainStream = FirebaseFirestore.instance
        .collection('bargains')
        .where('buyerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('confirmed', isEqualTo: true)
        .where('accepted', isEqualTo: true)
        .snapshots();

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
              'No Bargain Request Accepted',
              style: subTitle,
            ),
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
                    child: Icon(Icons.access_time),
                  ),
                  title: Text(
                    'Accepted',
                    style: TextStyle(color: Colors.green),
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
            );
          }).toList(),
        );
      },
    );
  }
}
