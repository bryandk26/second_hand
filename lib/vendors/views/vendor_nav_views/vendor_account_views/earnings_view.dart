import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/theme.dart';
import 'package:intl/intl.dart';

class EarningsView extends StatelessWidget {
  const EarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('vendors');

    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('accepted', isEqualTo: true)
        .snapshots();

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
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(data['storeImage']),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(data['businessName'], style: subTitle),
                    ),
                  ],
                ),
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: _ordersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  double totalOrder = 0.0;
                  for (var orderItem in snapshot.data!.docs) {
                    totalOrder += orderItem['productPrice'];
                  }

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade900,
                              borderRadius: BorderRadius.circular(
                                32,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'TOTAL EARNINGS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    '${NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(totalOrder)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade900,
                              borderRadius: BorderRadius.circular(
                                32,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'TOTAL ORDERS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
        }
        return Center(
            child: CircularProgressIndicator(
          color: Colors.yellow.shade900,
        ));
      },
    );
  }
}
