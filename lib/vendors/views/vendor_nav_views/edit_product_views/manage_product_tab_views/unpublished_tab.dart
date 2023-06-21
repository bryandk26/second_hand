import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/edit_product_views/edit_product_detail_view.dart';

class UnpublishedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final Stream<QuerySnapshot> _vendorProductsStream = FirebaseFirestore
        .instance
        .collection('products')
        .where('vendorId', isEqualTo: _auth.currentUser!.uid)
        .where('approved', isEqualTo: false)
        .snapshots();

    Future<void> deleteProduct(String productId) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure want to delete this product?'),
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
                    'Product has been deleted',
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 60,
                    ),
                  );
                  await _firestore
                      .collection('products')
                      .doc(productId)
                      .delete();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> publishProduct(String productId) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure want to publish this product?'),
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
                    'Product has been published',
                    Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 60,
                    ),
                  );
                  await _firestore
                      .collection('products')
                      .doc(productId)
                      .update({'approved': true});
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
                'No Unpublished Product Yet',
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
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return EditProductDetailView(
                            productData: vendorProductsData,
                          );
                        },
                      ));
                    },
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
                  ),
                  key: const ValueKey(0),
                  startActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        flex: 2,
                        onPressed: (context) async {
                          await publishProduct(vendorProductsData['productId']);
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.archive,
                        label: 'Publish',
                      ),
                      SlidableAction(
                        flex: 2,
                        onPressed: (context) async {
                          await deleteProduct(vendorProductsData['productId']);
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
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
