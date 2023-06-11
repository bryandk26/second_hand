import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/auth/authentication_wrapper.dart';
import 'package:second_chance/role_view.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/views/vendor_main_screen.dart';
import 'package:second_chance/vendors/views/auth/vendor_register_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    //Membuat instance dari Cloud Firestore dan memilih collection 'vendors'.
    final CollectionReference _vendorsStream =
        FirebaseFirestore.instance.collection('vendors');

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        //DocumentSnapshot able to pick just one data unlike QuerySnapshot
        stream: _vendorsStream
            .doc(_auth.currentUser!.uid)
            .snapshots(), //Membuat stream dari koleksi vendors yang mengambil data dari document dengan id sesuai dengan currentUser.uid.
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          if (!snapshot.data!.exists) {
            return VendorRegistrationScreen();
          }

          Map<String, dynamic> vendorData =
              snapshot.data!.data() as Map<String, dynamic>;

          if (vendorData['approved'] == true) {
            return VendorMainScreen();
          }

          String storeImage = vendorData['storeImage'];
          if (storeImage.isEmpty) {
            storeImage =
                'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg';
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    storeImage,
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  vendorData['businessName'],
                  style: titleText,
                ),
                SizedBox(height: 10),
                Text(
                  'Your application has been sent to shop admin\nAdmin will get back to you soon',
                  style: normalText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    await _auth.signOut();

                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return AuthenticationWrapper();
                      },
                    ));
                  },
                  child: Text('SignOut'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return RoleView();
                      },
                    ));
                  },
                  child: Text('Switch app'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
