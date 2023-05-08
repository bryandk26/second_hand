import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/auth/login_view.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({super.key});

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'VendorScreen',
            ),
            TextButton(
                onPressed: () async {
                  await _auth.signOut();
                  setState(() {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return LoginView();
                      },
                    ));
                  });
                },
                child: Text('Logout'))
          ],
        ),
      ),
    );
  }
}
