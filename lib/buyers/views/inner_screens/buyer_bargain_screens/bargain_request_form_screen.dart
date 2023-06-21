import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/inner_screens/edit_profile_screen.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';
import 'package:uuid/uuid.dart';

class BargainRequestFormScreen extends StatefulWidget {
  final dynamic productData;
  const BargainRequestFormScreen({super.key, required this.productData});

  @override
  State<BargainRequestFormScreen> createState() =>
      _BargainRequestFormScreenState();
}

class _BargainRequestFormScreenState extends State<BargainRequestFormScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    late double bargainPrice;

    bool _isLoading = false;

    void submitBargainRequest() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });

        final bargainId = Uuid().v4();

        try {
          final snapshot =
              await users.doc(FirebaseAuth.instance.currentUser!.uid).get();
          if (snapshot.exists) {
            Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

            await FirebaseFirestore.instance
                .collection('bargains')
                .doc(bargainId)
                .set({
              'bargainId': bargainId,
              'bargainPrice': bargainPrice,
              'email': data['email'],
              'phone': data['phoneNumber'],
              'address': data['address'],
              'postalCode': data['postalCode'],
              'buyerId': data['buyerId'],
              'buyerPhoto': data['profileImage'],
              'fullName': data['fullName'],
              'vendorId': widget.productData['vendorId'],
              'businessName': widget.productData['businessName'],
              'productId': widget.productData['productId'],
              'productName': widget.productData['productName'],
              'productPrice': widget.productData['productPrice'],
              'category': widget.productData['category'],
              'productImage': widget.productData['imageUrlList'],
              'productSize': widget.productData['size'],
              'confirmed': false,
              'accepted': false,
              'bargainRequestDate': DateTime.now(),
            }).then((_) {
              Navigator.pop(context);
            });
            return displayDialog(
              context,
              'You Added ${widget.productData['productName']} To Your Bargain List',
              Icon(
                Icons.check,
                color: Colors.green,
                size: 60,
              ),
            );
          } else {
            displayDialog(
              context,
              'User data not found.',
              Icon(
                Icons.error,
                color: Colors.red,
                size: 60,
              ),
            );
          }
        } catch (error) {
          displayDialog(
            context,
            'Error submitting bargain request: $error',
            Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ),
          );
        } finally {
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
                'Bargain Price',
                style: subTitle,
              ),
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(28.0),
                  child: Column(
                    children: [
                      if (data['address'] != '' && data['postalCode'] != '')
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Shipping Information',
                                    style: subTitle,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return EditProfileScreen(
                                              userData: data);
                                        },
                                      ));
                                    },
                                    child: Icon(CupertinoIcons.pencil),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Name: ${data['fullName']}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Phone: ${data['phoneNumber']}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Address: ${data['address']}',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Postal Code: ${data['postalCode']}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      if (data['address'] != '' && data['postalCode'] != '')
                        SizedBox(
                          height: 20,
                        ),
                      TextFormGlobal(
                        text: 'Bargain Price',
                        textInputType: TextInputType.number,
                        labelText: 'Bargain Price',
                        context: context,
                        onChanged: (value) {
                          bargainPrice = double.parse(value);
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: data['address'] == '' || data['postalCode'] == ''
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
                          isLoading: _isLoading, text: 'Enter Billing Address'),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          submitBargainRequest();
                        },
                        child: ButtonGlobal(
                            isLoading: _isLoading, text: 'SUBMIT')),
                  ),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            color: Colors.yellow.shade900,
          ),
        );
      },
    );
  }
}
