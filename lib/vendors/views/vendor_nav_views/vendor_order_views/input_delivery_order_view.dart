import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';
import 'package:second_chance/vendors/views/vendor_main_screen.dart';

class InputDeliveryOrderView extends StatelessWidget {
  final dynamic orderData;
  const InputDeliveryOrderView({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    late String expedition;
    late String receipt;

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
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(28.0),
            child: Column(
              children: [
                TextFormGlobal(
                  text: 'Expedition Name',
                  textInputType: TextInputType.text,
                  labelText: 'Expedition Name',
                  context: context,
                  onChanged: (value) {
                    expedition = value;
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  text: 'Delivery Receipt',
                  textInputType: TextInputType.text,
                  labelText: 'Delivery Receipt',
                  context: context,
                  onChanged: (value) {
                    receipt = value;
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

                FirebaseFirestore.instance
                    .collection('orders')
                    .doc(orderData['orderId'])
                    .update({
                  'expedition': expedition,
                  'receipt': receipt,
                  'status': 'On Delivery',
                }).then((_) {
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
