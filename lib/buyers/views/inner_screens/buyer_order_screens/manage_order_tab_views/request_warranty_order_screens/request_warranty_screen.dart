import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';
import 'package:second_chance/vendors/views/vendor_main_screen.dart';

class RequestWarrantyOrderScreen extends StatefulWidget {
  final dynamic orderData;
  const RequestWarrantyOrderScreen({super.key, required this.orderData});

  @override
  State<RequestWarrantyOrderScreen> createState() =>
      _RequestWarrantyOrderScreenState();
}

class _RequestWarrantyOrderScreenState
    extends State<RequestWarrantyOrderScreen> {
  XFile? _image;
  Future<void> uploadPaymentReceipt() async {
    EasyLoading.show(status: 'Please Wait');

    if (_image != null) {
      final String orderId = widget.orderData['orderId'];

      try {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('requestWarranty')
            .child('$orderId.jpg');

        Uint8List imageBytes = await _image!.readAsBytes();

        UploadTask uploadTask = ref.putData(imageBytes);

        TaskSnapshot snapshot = await uploadTask;

        String imageUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .update({'warrantyImage': imageUrl}).whenComplete(() {
          EasyLoading.dismiss();
        });
      } catch (e) {
        EasyLoading.showError('Error uploading request warranty image: $e');
        EasyLoading.dismiss();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    Future<void> _pickImageFromGallery() async {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _image = pickedImage;
        });
      }
    }

    late String reason;

    bool _isLoading = false;

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
          'Delivery Order Information',
          style: subTitle,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.grey[200],
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        'Upload Request Warranty Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: widget.orderData
                              .data()!
                              .containsKey('warrantyImage')
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PhotoView(
                                      backgroundDecoration:
                                          BoxDecoration(color: whiteColor),
                                      imageProvider: NetworkImage(
                                          widget.orderData['warrantyImage']),
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  widget.orderData['warrantyImage'],
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _pickImageFromGallery,
                              child: Text('Add Image'),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormGlobal(
                    text: 'Reason of Request Warranty ',
                    textInputType: TextInputType.text,
                    context: context,
                    onChanged: (value) {
                      reason = value;
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                _isLoading = true;

                FirebaseFirestore.instance
                    .collection('orders')
                    .doc(widget.orderData['orderId'])
                    .update({
                  'requestReason': reason,
                  'status': 'Request Warranty',
                }).then((_) async {
                  await uploadPaymentReceipt();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VendorMainScreen(
                          initialIndex: 3,
                        ),
                      ));
                }).catchError((error) {
                  displayDialog(
                    context,
                    'Error submitting delivery order: $error',
                    Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 60,
                    ),
                  );
                  _isLoading = false;
                });
              }
            },
            child: ButtonGlobal(isLoading: _isLoading, text: 'SUBMIT')),
      ),
    );
  }
}
