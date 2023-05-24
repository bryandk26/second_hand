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
import 'package:second_chance/buyers/views/main_screen.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/theme.dart';

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
          // Create a reference to the paymentReceipt image file in the 'paymentReceipt' folder
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('paymentReceipt')
              .child('$orderId.jpg');

          // Read the image data as Uint8List from XFile
          Uint8List imageBytes = await _image!.readAsBytes();

          // Upload the image data to the storage bucket
          UploadTask uploadTask = ref.putData(imageBytes);

          // Await for the upload to complete
          TaskSnapshot snapshot = await uploadTask;

          // Get the download URL of the uploaded image
          String imageUrl = await snapshot.ref.getDownloadURL();

          // Update the 'paymentReceipt' field in the 'orders' collection with the download URL
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(orderId)
              .update({
            'paymentReceipt': imageUrl,
            'status': 'Paid'
          }).whenComplete(() {
            EasyLoading.dismiss();
            Navigator.pop(context);
          });
        } catch (e) {
          print('Error uploading payment receipt: $e');
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
      body: Padding(
        padding:
            const EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 125),
        child: SingleChildScrollView(
          child: Card(
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
                      color: widget.orderData.data()!.containsKey('status')
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  Text(
                      'Price: ${currencyFormatter.format(widget.orderData['productPrice'])}'),
                  Text(
                      'Order Date: ${dateFormatter.format(widget.orderData['orderDate'].toDate())}'),
                  if (widget.orderData.data()!.containsKey('expedition'))
                    Text('Expedition: ${widget.orderData['expedition']}'),
                  if (widget.orderData.data()!.containsKey('receipt'))
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
                  SizedBox(height: 16),
                  ConditionalBuilder(
                    condition: widget.orderData['accepted'] == true,
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
                                      builder: (context) => PhotoView(
                                        backgroundDecoration:
                                            BoxDecoration(color: whiteColor),
                                        imageProvider: NetworkImage(
                                            widget.orderData['paymentReceipt']),
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    widget.orderData['paymentReceipt'],
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
                    fallback: (context) => ElevatedButton(
                      onPressed: _pickImageFromGallery,
                      child: Text('Upload Payment Receipt'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
                                          .update({
                                        'status': 'Done',
                                      }).then((_) {
                                        FirebaseFirestore.instance
                                            .collection('products')
                                            .doc(widget.orderData['productId'])
                                            .update({
                                          'sold': true,
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen(),
                                            ));
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
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
                        onTap: () {},
                        child: ButtonGlobal(
                          isLoading: _isLoading,
                          text: 'SUBMIT WARRANTY',
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
