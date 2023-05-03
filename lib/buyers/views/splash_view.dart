import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:second_chance/buyers/views/auth/login_view.dart';
import 'package:second_chance/theme.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return LoginView();
          },
        ));
      });
    });
    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
          child: Image.asset(
        'assets/images/logo.png',
        width: 150,
        height: 150,
      )),
    );
  }
}
