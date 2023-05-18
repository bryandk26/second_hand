import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/theme.dart';

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
    // final CartProvider _cartProvider = Provider.of<CartProvider>(context);

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
          widget.productData['productName'],
          style: TextStyle(
            color: blackColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                            widget.productData['imageUrlList'][_imageIndex],
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
                      itemCount: widget.productData['imageUrlList'].length,
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
                                widget.productData['imageUrlList'][index],
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
            SizedBox(height: 24),
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
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {},
                child: ButtonGlobal(isLoading: _isLoading, text: 'ADD TO CART'),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () {},
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
