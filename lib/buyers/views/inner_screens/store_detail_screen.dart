import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:second_chance/buyers/views/inner_screens/product_detail_screen.dart';
import 'package:second_chance/theme.dart';

class StoreDetailScreen extends StatelessWidget {
  final dynamic storeData;

  const StoreDetailScreen({super.key, required this.storeData});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('vendorId', isEqualTo: storeData['vendorId'])
        .where('approved', isEqualTo: true)
        .where('sold', isEqualTo: false)
        .where('onPayment', isEqualTo: false)
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
          storeData['businessName'],
          style: subTitle,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: blackColor,
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No Product Uploaded',
                style: subTitle,
              ),
            );
          }

          return GridView.builder(
            itemCount: snapshot.data!.size, //also the same with .docs.length
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 200 / 300,
            ),
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              final productImage = productData['imageUrlList'][0];

              void updateViewedField() {
                FirebaseFirestore.instance
                    .collection('products')
                    .doc(productData['productId'])
                    .update({
                  'viewed': FieldValue.increment(1),
                });
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      updateViewedField();
                      return ProductDetailScreen(
                        productData: productData,
                      );
                    },
                  ));
                },
                child: Card(
                  child: Column(
                    children: [
                      Container(
                        height: 170,
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              productImage,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          productData['productName'],
                          style: subTitle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(productData['productPrice'])}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
