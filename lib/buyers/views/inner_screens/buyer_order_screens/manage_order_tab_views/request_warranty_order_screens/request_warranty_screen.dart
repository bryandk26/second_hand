import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_chance/buyers/views/inner_screens/edit_profile_screen.dart';
import 'package:second_chance/buyers/views/main_screen.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';

class RequestWarrantyOrderScreen extends StatefulWidget {
  final dynamic orderData;
  const RequestWarrantyOrderScreen({super.key, required this.orderData});

  @override
  State<RequestWarrantyOrderScreen> createState() =>
      _RequestWarrantyOrderScreenState();
}

class _RequestWarrantyOrderScreenState
    extends State<RequestWarrantyOrderScreen> {
  File? _pickedImageFile;

  Future<void> uploadPaymentReceipt() async {
    EasyLoading.show(status: 'Please Wait');

    if (_pickedImageFile != null) {
      final String orderId = widget.orderData['orderId'];

      try {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('requestWarranty')
            .child('$orderId.jpg');

        Uint8List imageBytes = await _pickedImageFile!.readAsBytes();

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
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    late String reason;

    bool _isLoading = false;

    Future<void> _pickImageFromGallery() async {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedImage =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _pickedImageFile = File(pickedImage.path);
        });
      }
    }

    Future<void> submitWarrantyRequest() async {
      if (_formKey.currentState!.validate()) {
        if (_pickedImageFile == null) {
          displayDialog(
            context,
            'Please select an image',
            Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ),
          );
        } else {
          setState(() {
            _isLoading = true;
          });

          try {
            String orderId = widget.orderData['orderId'];

            await FirebaseFirestore.instance
                .collection('orders')
                .doc(orderId)
                .update({
              'requestReason': reason,
              'status': 'Request Warranty',
            });

            await uploadPaymentReceipt();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ),
            );

            displayDialog(
              context,
              'Your warranty request has been submitted',
              Icon(
                Icons.check,
                color: Colors.green,
                size: 60,
              ),
            );
          } catch (error) {
            displayDialog(
              context,
              'Error submitting warranty request: $error',
              Icon(
                Icons.error,
                color: Colors.red,
                size: 60,
              ),
            );
          }

          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                              subtitle: (_pickedImageFile != null)
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        _pickedImageFile!,
                                        fit: BoxFit.cover,
                                        height: 200,
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
                            text: 'Reason of Request Warranty',
                            textInputType: TextInputType.multiline,
                            labelText: 'Reason of Request Warranty',
                            context: context,
                            onChanged: (value) {
                              reason = value;
                              return null;
                            },
                            maxLength: 800,
                            maxLines: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            bottomSheet: data['bankName'] == '' ||
                    data['bankAccountName'] == '' ||
                    data['bankAccountNumber'] == ''
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return EditProfileScreen(
                            userData: data,
                          );
                        })).whenComplete(() {
                          Navigator.pop(context);
                        });
                      },
                      child: ButtonGlobal(
                          isLoading: _isLoading, text: 'Enter Bank Account'),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => submitWarrantyRequest(),
                      child:
                          ButtonGlobal(isLoading: _isLoading, text: 'SUBMIT'),
                    ),
                  ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: blackColor,
          ),
        );
      },
    );
  }
}
