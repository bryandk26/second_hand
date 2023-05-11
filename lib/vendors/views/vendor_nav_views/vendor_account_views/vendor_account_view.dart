import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:second_chance/auth/authentication_wrapper.dart';
import 'package:second_chance/buyers/views/widgets/profile_menu_widget.dart';
import 'package:second_chance/role_view.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/models/vendor_user_models.dart';
import 'package:second_chance/vendors/views/vendor_nav_views/vendor_account_views/vendor_edit_account_view.dart';

class VendorAccountView extends StatelessWidget {
  const VendorAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('vendors');
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(_auth.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          VendorUserModel vendorUserModel = VendorUserModel.fromJson(
              snapshot.data!.data()! as Map<String, dynamic>);

          String storeImage = vendorUserModel.storeImage.toString();
          if (storeImage.isEmpty) {
            storeImage =
                'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg';
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: whiteColor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Vendor Profile',
                style: subTitle,
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          storeImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      vendorUserModel.businessName.toString(),
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      vendorUserModel.email.toString(),
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return VendorEditAccountView(
                                vendorData: vendorUserModel,
                              );
                            },
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blackColor,
                          side: BorderSide.none,
                          shape: StadiumBorder(),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                              color: whiteColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Divider(),
                    SizedBox(height: 10),
                    ProfileMenuWidget(
                      title: 'Settings',
                      icon: Icons.settings_outlined,
                      onPress: () {},
                    ),
                    ProfileMenuWidget(
                      title: 'Cart',
                      icon: Icons.add_shopping_cart,
                      onPress: () {},
                    ),
                    ProfileMenuWidget(
                      title: 'Orders',
                      icon: Icons.shopping_cart,
                      onPress: () {},
                    ),
                    Divider(),
                    ProfileMenuWidget(
                      title: 'Switch App',
                      icon: Icons.info_outline,
                      onPress: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return RoleView();
                          },
                        ));
                      },
                    ),
                    ProfileMenuWidget(
                      title: 'Logout',
                      icon: Icons.logout_rounded,
                      textColor: primaryColor,
                      endIcon: false,
                      onPress: () async {
                        EasyLoading.show(status: 'Logging out');

                        await _auth.signOut().whenComplete(
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return AuthenticationWrapper();
                                },
                              ),
                            );

                            EasyLoading.dismiss();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}