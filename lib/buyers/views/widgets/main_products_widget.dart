import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/inner_screens/product_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:second_chance/theme.dart';

class MainProductsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('approved', isEqualTo: true)
        .where('sold', isEqualTo: false)
        .where('onPayment', isEqualTo: false)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LinearProgressIndicator(
              color: blackColor,
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Container(
            height: 260,
            alignment: Alignment.center,
            child: Center(
              child: Text(
                'No Product',
                style: subTitle,
              ),
            ),
          );
        }

        return Container(
          height: MediaQuery.of(context).size.height * 0.54,
          child: GridView.builder(
              itemCount: snapshot.data!.size,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 200 / 300,
              ),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];

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
                    updateViewedField();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductDetailScreen(
                        productData: productData,
                      );
                    }));
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
                                productData['imageUrlList'][0],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                productData['productName'],
                                style: cardTitle,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '${NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(productData['productPrice'])}',
                                style: subTitle.apply(color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
