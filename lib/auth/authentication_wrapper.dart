import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/auth/login_view.dart';
import 'package:second_chance/role_view.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // User is signed in
          return RoleView();
        } else {
          // User is not signed in
          return LoginView();
        }
      },
    );
  }
}
