import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:second_chance/auth/authentication_wrapper.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_bargain_screens/buyer_bargain_requests_screen.dart';
import 'package:second_chance/buyers/views/inner_screens/buyer_order_screens/buyer_orders_tab_view.dart';
import 'package:second_chance/buyers/views/inner_screens/edit_profile_screen.dart';
import 'package:second_chance/buyers/views/widgets/profile_menu_widget.dart';
import 'package:second_chance/provider/cart_provider.dart';
import 'package:second_chance/role_view.dart';
import 'package:second_chance/theme.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    final FirebaseAuth _auth = FirebaseAuth.instance;

    void handleLogout(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Logout'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  EasyLoading.show(status: 'Logging out');
                  Provider.of<CartProvider>(context, listen: false)
                      .removeAllCartItem();

                  await _auth.signOut().then((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthenticationWrapper(),
                      ),
                    );
                  }).whenComplete(() {
                    EasyLoading.dismiss();
                  });
                },
              ),
            ],
          );
        },
      );
    }

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
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          String profileImage = data['profileImage'];
          if (profileImage.isEmpty) {
            profileImage =
                'https://www.personality-insights.com/wp-content/uploads/2017/12/default-profile-pic-e1513291410505.jpg';
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: whiteColor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'Profile',
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
                          profileImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      data['fullName'],
                      style: TextStyle(
                        color: blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      data['email'],
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
                              return EditProfileScreen(userData: data);
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
                      title: 'Bargain Request',
                      icon: Icons.money,
                      onPress: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return BuyerBargainRequestsScreen();
                          },
                        ));
                      },
                    ),
                    ProfileMenuWidget(
                      title: 'Orders',
                      icon: Icons.shopping_cart,
                      onPress: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return BuyerOrderTabView();
                          },
                        ));
                      },
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
                      onPress: () {
                        handleLogout(context);
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
