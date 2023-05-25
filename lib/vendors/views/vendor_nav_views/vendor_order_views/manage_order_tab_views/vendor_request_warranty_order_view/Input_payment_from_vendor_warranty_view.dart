import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/views/vendor_main_screen.dart';

class InputPaymentFromVendorWarrantyView extends StatefulWidget {
  final dynamic orderData;
  const InputPaymentFromVendorWarrantyView(
      {super.key, required this.orderData});

  @override
  State<InputPaymentFromVendorWarrantyView> createState() =>
      _InputPaymentFromVendorWarrantyViewState();
}

class _InputPaymentFromVendorWarrantyViewState
    extends State<InputPaymentFromVendorWarrantyView> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    XFile? _image;

    Future<void> uploadRefundWarranty() async {
      EasyLoading.show(status: 'Please Wait');

      if (_image != null) {
        final String orderId = widget.orderData['orderId'];

        try {
          // Create a reference to the paymentReceipt image file in the 'paymentReceipt' folder
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('RefundWarranty')
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
            'refundWarrantyReceipt': imageUrl,
            'status': 'Warranty Taken'
          }).whenComplete(() {
            EasyLoading.dismiss();
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return VendorMainScreen(
                  initialIndex: 3,
                );
              },
            ));
          });
        } catch (e) {
          EasyLoading.showError('Error uploading refund warranty receipt: $e');
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
        uploadRefundWarranty();
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
          'Payment Warranty Order Information',
          style: subTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(28.0),
            child: ConditionalBuilder(
              condition: widget.orderData['accepted'] == true &&
                  widget.orderData['status'] != 'Canceled',
              builder: (context) => Card(
                color: Colors.grey[200],
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text(
                    'Refund Warrantly Receipt',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: widget.orderData
                          .data()!
                          .containsKey('refundWarrantyReceipt')
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoView(
                                  backgroundDecoration:
                                      BoxDecoration(color: whiteColor),
                                  imageProvider: NetworkImage(widget
                                      .orderData['refundWarrantyReceipt']),
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              widget.orderData['refundWarrantyReceipt'],
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
          ),
        ),
      ),
    );
  }
}
