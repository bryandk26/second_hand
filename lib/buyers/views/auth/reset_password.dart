import 'package:flutter/material.dart';
import 'package:second_chance/buyers/views/auth/login_view.dart';
import 'package:second_chance/buyers/views/widgets/primary_button.dart';
import 'package:second_chance/buyers/views/widgets/reset_form.dart';
import 'package:second_chance/theme.dart';

class ResetPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: kDefaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
            ),
            Text(
              'Reset Password',
              style: titleText,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Please enter your email address',
              style: subTitle.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            ResetForm(),
            SizedBox(
              height: 40,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogInView(),
                      ));
                },
                child: PrimaryButton(buttonText: 'Reset Password')),
          ],
        ),
      ),
    );
  }
}
