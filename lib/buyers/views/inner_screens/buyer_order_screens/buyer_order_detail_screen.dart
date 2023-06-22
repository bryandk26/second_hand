import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_order_screens/manage_order_tab_views/request_warranty_order_screens/request_warranty_screen.dart';
import 'package:second_chance/buyers/views/main_screen.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';

class BuyerOrderDetailScreen extends StatefulWidget {
  final dynamic orderData;

  const BuyerOrderDetailScreen({Key? key, required this.orderData})
      : super(key: key);

  @override
  State<BuyerOrderDetailScreen> createState() => _BuyerOrderDetailScreenState();
}

class _BuyerOrderDetailScreenState extends State<BuyerOrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorsStream = FirebaseFirestore.instance
        .collection('vendors')
        .where('vendorId', isEqualTo: widget.orderData['vendorId'])
        .snapshots();
    bool _isLoading = false;

    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
    );
    final DateFormat dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    XFile? _image;

    Future<void> uploadPaymentReceipt() async {
      EasyLoading.show(status: 'Please Wait');

      if (_image != null) {
        final String orderId = widget.orderData['orderId'];

        try {
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('paymentReceipt')
              .child('$orderId.jpg');
          Uint8List imageBytes = await _image!.readAsBytes();
          UploadTask uploadTask = ref.putData(imageBytes);
          TaskSnapshot snapshot = await uploadTask;
          String imageUrl = await snapshot.ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('orders')
              .doc(orderId)
              .update({
            'paymentReceipt': imageUrl,
            'status': 'Paid'
          }).whenComplete(() {
            EasyLoading.dismiss();
            Navigator.pop(context);
            displayDialog(
              context,
              'Your payment receipt has been submitted',
              Icon(
                Icons.check,
                color: Colors.green,
                size: 60,
              ),
            );
          });
        } catch (e) {
          EasyLoading.showError('Error uploading payment receipt: $e');
          EasyLoading.dismiss();
        }
      }
    }

    Future<void> _pickImageFromGallery() async {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
        });
        uploadPaymentReceipt();
      }
    }

    Future<void> handleReceiveOrder() async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Have you received the item?'),
            actions: <Widget>[
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('orders')
                      .doc(widget.orderData['orderId'])
                      .update({'status': 'Done'}).then((_) {
                    FirebaseFirestore.instance
                        .collection('products')
                        .doc(widget.orderData['productId'])
                        .update({
                      'sold': true,
                      'productPrice': widget.orderData['productPrice'],
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                    displayDialog(
                      context,
                      'Your order has been completed!',
                      Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 60,
                      ),
                    );
                  });
                },
              ),
            ],
          );
        },
      );
    }

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
          'Order Detail',
          style: subTitle,
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
              return Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Image.network(
                                    widget.orderData['productImage'][0],
                                  ),
                                ),
                                title: Text(
                                  'Product Name: ${widget.orderData['productName']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Order Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Status: ${widget.orderData.data()!.containsKey('status') ? widget.orderData.data()!['status'] : 'Not Accepted'}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.orderData
                                          .data()!
                                          .containsKey('status')
                                      ? Colors.blue
                                      : Colors.red,
                                ),
                              ),
                              Text(
                                  'Price: ${currencyFormatter.format(widget.orderData['productPrice'])}'),
                              Text(
                                  'Order Date: ${dateFormatter.format(widget.orderData['orderDate'].toDate())}'),
                              if (widget.orderData
                                  .data()!
                                  .containsKey('expedition'))
                                Text(
                                    'Expedition: ${widget.orderData['expedition']}'),
                              if (widget.orderData
                                  .data()!
                                  .containsKey('receipt'))
                                Text('Receipt: ${widget.orderData['receipt']}'),
                              SizedBox(height: 16),
                              Text(
                                'Buyer Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Name: ${widget.orderData['fullName']}'),
                              Text('Email: ${widget.orderData['email']}'),
                              Text('Address: ${widget.orderData['address']}'),
                              Text(
                                  'Postal Code: ${widget.orderData['postalCode']}'),
                              SizedBox(height: 16),
                              Text(
                                'Vendor Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Name: ${storeData['businessName']}'),
                              Text('Bank Name: ${storeData['vendorBankName']}'),
                              Text(
                                  'Bank Account Name: ${storeData['vendorBankAccountName']}'),
                              Text(
                                  'Bank Account Number: ${storeData['vendorBankAccountNumber']}'),
                              SizedBox(height: 16),
                              ConditionalBuilder(
                                condition: widget.orderData['accepted'] ==
                                        true &&
                                    widget.orderData['status'] != 'Canceled',
                                builder: (context) => Card(
                                  color: Colors.grey[200],
                                  elevation: 2.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      'Payment Receipt',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: widget.orderData
                                            .data()!
                                            .containsKey('paymentReceipt')
                                        ? GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PhotoView(
                                                    backgroundDecoration:
                                                        BoxDecoration(
                                                            color: whiteColor),
                                                    imageProvider: NetworkImage(
                                                        widget.orderData[
                                                            'paymentReceipt']),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.network(
                                                widget.orderData[
                                                    'paymentReceipt'],
                                                fit: BoxFit.cover,
                                                height: 200,
                                              ),
                                            ),
                                          )
                                        : ElevatedButton(
                                            onPressed: _pickImageFromGallery,
                                            child: Text('Add Receipt'),
                                          ),
                                  ),
                                ),
                                fallback: (context) => Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.orderData.data()!.containsKey('status') &&
                          widget.orderData['status'] == 'On Delivery')
                        SizedBox(
                          height: 125,
                        )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomSheet: widget.orderData.data()!.containsKey('status') &&
              widget.orderData['status'] == 'On Delivery'
          ? Container(
              height: 125,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          handleReceiveOrder();
                        },
                        child: ButtonGlobal(
                          isLoading: _isLoading,
                          text: 'ORDER RECEIVED',
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RequestWarrantyOrderScreen(
                                        orderData: widget.orderData),
                              ));
                        },
                        child: ButtonGlobal(
                          isLoading: _isLoading,
                          text: 'REQUEST WARRANTY',
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
