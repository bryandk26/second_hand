import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_bargain_screens/bargain_request_form_screen.dart';
import 'package:second_chance/buyers/views/inner_screens/store_detail_screen.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/provider/cart_provider.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _imageIndex = 0;
  bool _isLoading = false;

  String formatedDate(date) {
    final outPutDateFormat = DateFormat('dd/MM/yyy');

    final outPutDate = outPutDateFormat.format(date);

    return outPutDate;
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    final Stream<QuerySnapshot> _vendorsStream = FirebaseFirestore.instance
        .collection('vendors')
        .where('vendorId', isEqualTo: widget.productData['vendorId'])
        .snapshots();

    void updateViewedField() {
      FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productData['productId'])
          .update({
        'viewed': FieldValue.increment(1),
      });
    }

    updateViewedField();

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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Icon(
                  Icons.remove_red_eye,
                  color: blackColor,
                ),
                SizedBox(width: 5),
                Text(
                  '${widget.productData['viewed']}',
                  style: subTitle,
                ),
              ],
            ),
          ),
        ],
        title: Text(
          widget.productData['productName'],
          style: TextStyle(
            color: blackColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _vendorsStream,
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

          return ListView.builder(
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              final storeData = snapshot.data!.docs[index];
              final storeImage = storeData['storeImage'];
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoView(
                                  backgroundDecoration:
                                      BoxDecoration(color: whiteColor),
                                  imageProvider: NetworkImage(
                                    widget.productData['imageUrlList']
                                        [_imageIndex],
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            color: lightGreyColor,
                            child: SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: Image.network(
                                widget.productData['imageUrlList'][_imageIndex],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  widget.productData['imageUrlList'].length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _imageIndex = index;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: whiteColor,
                                        border: Border.all(
                                          color: primaryColor,
                                        ),
                                      ),
                                      height: 60,
                                      width: 60,
                                      child: Image.network(
                                        widget.productData['imageUrlList']
                                            [index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.productData['productName'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '${NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(widget.productData['productPrice'])}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return StoreDetailScreen(
                              storeData: storeData,
                            );
                          },
                        ));
                      },
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: ListTile(
                          title: Text(storeData['businessName']),
                          subtitle: Text(storeData['countryValue']),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              storeImage == null || storeImage == ''
                                  ? 'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg'
                                  : storeData['storeImage'],
                            ),
                          ),
                          trailing: Icon(
                            CupertinoIcons.forward,
                            size: 18.0,
                            color: blackColor,
                          ),
                        ),
                      ),
                    ),
                    ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Size',
                            style: subTitle,
                          ),
                          Text(
                            'View More',
                            style: subTitle.apply(color: Colors.blue),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.productData['size'],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Product Description',
                            style: subTitle,
                          ),
                          Text(
                            'View More',
                            style: subTitle.apply(color: Colors.blue),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.productData['productDescription'],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 75,
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        child: _cartProvider.getCartItem
                .containsKey(widget.productData['productId'])
            ? ButtonGlobal(
                isLoading: _isLoading,
                text: 'ALREADY IN CART',
                color: greyColor,
              )
            : Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _cartProvider.addProductToCart(
                          widget.productData['productName'],
                          widget.productData['productId'],
                          widget.productData['imageUrlList'],
                          widget.productData['productPrice'],
                          widget.productData['vendorId'],
                          widget.productData['size'],
                          widget.productData['businessName'],
                        );

                        return displayDialog(
                          context,
                          'You Added ${widget.productData['productName']} To Your Cart',
                          Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 60,
                          ),
                        );
                      },
                      child: ButtonGlobal(
                          isLoading: _isLoading, text: 'ADD TO CART'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BargainRequestFormScreen(
                                  productData: widget.productData),
                            ));
                      },
                      child: ButtonGlobal(
                        isLoading: _isLoading,
                        text: 'BARGAIN',
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
