import 'package:flutter/material.dart';

void displayDialog(BuildContext context, String message, dynamic title) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: AlertDialog(
          title: title,
          content: Text(message),
        ),
      );
    },
  );
}
