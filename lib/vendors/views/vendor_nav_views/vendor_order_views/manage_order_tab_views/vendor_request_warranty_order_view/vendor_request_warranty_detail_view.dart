import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_order_views/manage_order_tab_views/vendor_request_warranty_order_view/Input_payment_from_vendor_warranty_view.dart';

class VendorRequestWarrantyDetailView extends StatefulWidget {
  final dynamic orderData;

  const VendorRequestWarrantyDetailView({Key? key, required this.orderData})
      : super(key: key);

  @override
  State<VendorRequestWarrantyDetailView> createState() =>
      _VendorRequestWarrantyDetailViewState();
}

class _VendorRequestWarrantyDetailViewState
    extends State<VendorRequestWarrantyDetailView> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    bool _isLoading = false;
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
    );
    final DateFormat dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

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
          'Warranty Order Detail',
          style: subTitle,
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
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
                              'Warranty Order Details',
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
                            Text(
                                'Request Reason: ${(widget.orderData['requestReason'])}'),
                            if (widget.orderData
                                .data()!
                                .containsKey('warrantyExpedition'))
                              Text(
                                  'Expedition: ${widget.orderData['warrantyExpedition']}'),
                            if (widget.orderData
                                .data()!
                                .containsKey('warrantyReceipt'))
                              Text(
                                  'Receipt: ${widget.orderData['warrantyReceipt']}'),
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
                            Text('Bank Name: ${data['bankName']}'),
                            Text(
                                'Bank Account Name: ${data['bankAccountName']}'),
                            Text(
                                'Bank Account Number: ${data['bankAccountNumber']}'),
                            SizedBox(height: 16),
                            Card(
                              color: Colors.grey[200],
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                  title: Text(
                                    'Warranty Product Image',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PhotoView(
                                            backgroundDecoration: BoxDecoration(
                                                color: whiteColor),
                                            imageProvider: NetworkImage(widget
                                                .orderData['warrantyImage']),
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
                                  )),
                            ),
                            if (widget.orderData
                                .data()!
                                .containsKey('refundWarrantyReceipt'))
                              Card(
                                color: Colors.grey[200],
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ListTile(
                                    title: Text(
                                      'Refund Receipt Image',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PhotoView(
                                              backgroundDecoration:
                                                  BoxDecoration(
                                                      color: whiteColor),
                                              imageProvider: NetworkImage(
                                                  widget.orderData[
                                                      'refundWarrantyReceipt']),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          widget.orderData[
                                              'refundWarrantyReceipt'],
                                          fit: BoxFit.cover,
                                          height: 200,
                                        ),
                                      ),
                                    )),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(
              color: Colors.yellow.shade900,
            ),
          );
        },
      ),
      bottomSheet: widget.orderData.data()!.containsKey('status') &&
              widget.orderData['status'] == 'Waiting Vendor Payment'
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              InputPaymentFromVendorWarrantyView(
                                  orderData: widget.orderData),
                        ));
                  },
                  child: ButtonGlobal(isLoading: _isLoading, text: 'REFUND')),
            )
          : null,
    );
  }
}
