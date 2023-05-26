import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/main_screen.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';
import 'package:uuid/uuid.dart';

class BargainRequestFormScreen extends StatelessWidget {
  final dynamic productData;
  const BargainRequestFormScreen({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    late double bargainPrice;

    bool _isLoading = false;

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
                      TextFormGlobal(
                        text: 'Bargain Price',
                        textInputType: TextInputType.number,
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
            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _isLoading = true;

                      final bargainId = Uuid().v4();

                      FirebaseFirestore.instance
                          .collection('bargains')
                          .doc(bargainId)
                          .set({
                        'bargainId': bargainId,
                        'bargainPrice': bargainPrice,
                        'email': data['email'],
                        'phone': data['phoneNumber'],
                        'address': data['address'],
                        'buyerId': data['buyerId'],
                        'buyerPhoto': data['profileImage'],
                        'fullName': data['fullName'],
                        'vendorId': productData['vendorId'],
                        'businessName': productData['businessName'],
                        'productId': productData['productId'],
                        'productName': productData['productName'],
                        'productPrice': productData['productPrice'],
                        'category': productData['category'],
                        'productImage': productData['imageUrlList'],
                        'productSize': productData['size'],
                        'confirmed': false,
                        'accepted': false,
                        'bargainRequestDate': DateTime.now(),
                      }).then((_) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreen(),
                            ));
                      }).catchError((error) {
                        displayDialog(
                          context,
                          'Error submitting bargain request: $error',
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

        return Center(
          child: CircularProgressIndicator(
            color: Colors.yellow.shade900,
          ),
        );
      },
    );
  }
}
