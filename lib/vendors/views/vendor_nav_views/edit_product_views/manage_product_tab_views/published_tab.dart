import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';

class PublishedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final Stream<QuerySnapshot> _vendorProductsStream = FirebaseFirestore
        .instance
        .collection('products')
        .where('vendorId', isEqualTo: _auth.currentUser!.uid)
        .where('approved', isEqualTo: true)
        .where('sold', isEqualTo: false)
        .where('onPayment', isEqualTo: false)
        .snapshots();

    Future<void> unpublishProduct(String productId) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure want to unpublish this product?'),
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
                    'Product has been unpublished',
                    Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 60,
                    ),
                  );
                  await _firestore
                      .collection('products')
                      .doc(productId)
                      .update({'approved': false});
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _vendorProductsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.yellow.shade900,
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Published Product Yet',
                style: subTitle,
              ),
            );
          }

          return Container(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final vendorProductsData = snapshot.data!.docs[index];

                return Slidable(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          child: Image.network(vendorProductsData[
                                      'imageUrlList'] !=
                                  null
                              ? vendorProductsData['imageUrlList'][0]
                              : 'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vendorProductsData['productName'],
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(vendorProductsData['productPrice'])}',
                                style: subTitle.apply(color: Colors.green),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  key: const ValueKey(0),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        flex: 2,
                        onPressed: (context) async {
                          await unpublishProduct(
                              vendorProductsData['productId']);
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.unarchive,
                        label: 'Unpublish',
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
