import 'package:flutter/material.dart';
import 'package:second_chance/theme.dart';

showSnack(context, String title) {
  Color snackColor;
  if (title == 'Your Account has been created!') {
    snackColor = blackColor;
  } else {
    snackColor = primaryColor;
  }

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: snackColor,
  ));
}
