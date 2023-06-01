import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/inner_screens/product_detail_screen.dart';
import 'package:second_chance/theme.dart';
import 'package:intl/intl.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

enum SortOption { AtoZ, ZtoA, MostViewed }

class _ProductsScreenState extends State<ProductsScreen> {
  final Stream<QuerySnapshot> _productsStream = FirebaseFirestore.instance
      .collection('products')
      .where('approved', isEqualTo: true)
      .where('sold', isEqualTo: false)
      .where('onPayment', isEqualTo: false)
      .snapshots();
  SortOption _sortOption = SortOption.AtoZ;

  String? _searchValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        centerTitle: true,
        elevation: 0,
        title: TextFormField(
          onChanged: (value) {
            setState(() {
              _searchValue = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Search Product...',
            labelStyle: TextStyle(
              color: blackColor,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: blackColor,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<SortOption>(
            icon: Icon(
              Icons.sort,
              color: blackColor,
            ),
            onSelected: (SortOption option) {
              setState(() {
                _sortOption = option;
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: SortOption.AtoZ,
                child: Text('A-Z'),
              ),
              PopupMenuItem(
                value: SortOption.ZtoA,
                child: Text('Z-A'),
              ),
              PopupMenuItem(
                value: SortOption.MostViewed,
                child: Text('Most Viewed'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final searchedData = snapshot.data!.docs.where((element) {
            return element['productName']
                .toLowerCase()
                .contains(_searchValue?.toLowerCase() ?? '');
          }).toList();

          if (searchedData.isEmpty) {
            return Center(
              child: Text(
                'Searched Product is Not Found',
                style: subTitle,
              ),
            );
          }

          List<QueryDocumentSnapshot> sortedList = searchedData;
          if (_sortOption == SortOption.AtoZ) {
            sortedList.sort((a, b) => a['productName']
                .toString()
                .toLowerCase()
                .compareTo(b['productName'].toString()));
          } else if (_sortOption == SortOption.ZtoA) {
            sortedList.sort((a, b) => b['productName']
                .toString()
                .toLowerCase()
                .compareTo(a['productName'].toString()));
          } else {
            sortedList.sort((a, b) => b['viewed'].compareTo(a['viewed']));
          }

          return ListView.builder(
            itemCount: sortedList.length,
            itemBuilder: (context, index) {
              final productData = sortedList[index];
              final productImage = productData['imageUrlList'][0];
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProductDetailScreen(
                        productData: productData,
                      );
                    },
                  ));
                },
                child: Card(
                  child: Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.network(
                          productImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productData['productName'],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(productData['productPrice'])}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      )
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
