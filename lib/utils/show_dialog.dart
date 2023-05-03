import 'package:flutter/material.dart';
import 'package:second_chance/theme.dart';

void displayDialog(BuildContext context, String message, dynamic title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: Container(
          width: double.maxFinite,
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: subTitle,
          ),
        ),
      );
    },
  );
}
