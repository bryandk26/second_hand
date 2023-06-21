import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/main_screen.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/buyers/views/widgets/text_form_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/utils/show_dialog.dart';

class InputWarrantyOrderView extends StatefulWidget {
  final dynamic orderData;
  const InputWarrantyOrderView({super.key, required this.orderData});

  @override
  State<InputWarrantyOrderView> createState() => _InputWarrantyOrderViewState();
}

class _InputWarrantyOrderViewState extends State<InputWarrantyOrderView> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    late String warrantyExpedition;
    late String warrantyReceipt;

    bool _isLoading = false;

    void submitWarrantyDeliveryDetail() {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });

        FirebaseFirestore.instance
            .collection('orders')
            .doc(widget.orderData['orderId'])
            .update({
          'warrantyExpedition': warrantyExpedition,
          'warrantyReceipt': warrantyReceipt,
          'status': 'Waiting Vendor Payment',
        }).then((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(
                initialIndex: 5,
              ),
            ),
          );
          displayDialog(
            context,
            'Your warranty receipt has been submitted',
            Icon(
              Icons.check,
              color: Colors.green,
              size: 60,
            ),
          );
        }).catchError((error) {
          displayDialog(
            context,
            'Error submitting delivery warranty order: $error',
            Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        });
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
          'Delivery Warranty Order Information',
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
                  text: 'Warranty Expedition Name',
                  textInputType: TextInputType.text,
                  labelText: 'Warranty Expedition Name',
                  context: context,
                  onChanged: (value) {
                    warrantyExpedition = value;
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormGlobal(
                  text: 'Warranty Delivery Receipt',
                  textInputType: TextInputType.text,
                  labelText: 'Warranty Delivery Receipt',
                  context: context,
                  onChanged: (value) {
                    warrantyReceipt = value;
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
            onTap: () => submitWarrantyDeliveryDetail(),
            child: ButtonGlobal(isLoading: _isLoading, text: 'SUBMIT')),
      ),
    );
  }
}
