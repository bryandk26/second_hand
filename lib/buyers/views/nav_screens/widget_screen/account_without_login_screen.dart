import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/auth/login_view.dart';
import 'package:second_chance/theme.dart';

class LoggedOutUserAccountScreen extends StatelessWidget {
  const LoggedOutUserAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: subTitle,
        ),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You are currently not logged in',
                textAlign: TextAlign.center,
                style: titleText,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return LoginView();
                        },
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blackColor,
                      side: BorderSide.none,
                      shape: StadiumBorder(),
                    ),
                    child: Text(
                      'Login Here',
                      style: TextStyle(
                          color: whiteColor, fontWeight: FontWeight.w600),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
