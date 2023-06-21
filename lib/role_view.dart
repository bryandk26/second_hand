import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/main_screen.dart';
import 'package:second_chance/buyers/views/widgets/button_global.dart';
import 'package:second_chance/theme.dart';
import 'package:second_chance/vendors/views/landing_screen.dart';

class RoleView extends StatelessWidget {
  const RoleView({super.key});

  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Text Only Without Background.png',
                  width: 125,
                  height: 125,
                ),
                SizedBox(
                  height: 50,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return MainScreen();
                      },
                    ));
                  },
                  child: ButtonGlobal(
                      isLoading: _isLoading, text: 'Open Customer App'),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'or',
                  style: subTitle.apply(color: primaryColor),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return LandingScreen();
                      },
                    ));
                  },
                  child: ButtonGlobal(
                      isLoading: _isLoading, text: 'Open Vendor App'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
