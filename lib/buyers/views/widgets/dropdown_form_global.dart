import 'package:flutter/material.dart';
import 'package:second_chance/theme.dart';

class DropdownFormGlobal<T> extends StatelessWidget {
  DropdownFormGlobal({
    super.key,
    this.controller,
    required this.text,
    required this.labelText,
    required this.onChanged,
    required this.context,
    this.enabled = true,
    required this.listData,
  });
  final TextEditingController? controller;
  final String text;
  final String labelText;
  final String? Function(T?)? onChanged;
  final BuildContext context;
  final bool enabled;
  final List<T?> listData;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      style: TextStyle(
        color: blackColor,
        fontSize: 16,
      ),
      hint: Text(
        'Select ${text}',
        style: TextStyle(
          color: greyColor,
          fontSize: 16,
        ),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? whiteColor : lightGreyColor,
        hintText: 'Enter ${text}',
        hintStyle: TextStyle(
          color: greyColor,
          fontSize: 16,
        ),
        labelText: '${labelText}',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please this fields must not be empty';
        } else {
          return null;
        }
      },
      items: listData.map<DropdownMenuItem<T>>(
        (e) {
          return DropdownMenuItem<T>(
            value: e,
            child: Text(e.toString()),
          );
        },
      ).toList(),
    );
  }
}
