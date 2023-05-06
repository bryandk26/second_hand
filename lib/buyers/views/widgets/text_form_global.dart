import 'package:flutter/material.dart';
import 'package:second_chance/theme.dart';

class TextFormGlobal extends StatelessWidget {
  TextFormGlobal({
    super.key,
    this.controller,
    required this.text,
    required this.textInputType,
    this.obsecure = false,
    this.onChanged,
    required this.context,
  });
  final TextEditingController? controller;
  final String text;
  final TextInputType textInputType;
  final bool obsecure;
  final String? Function(String)? onChanged;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller ?? null,
      keyboardType: textInputType,
      obscureText: obsecure,
      style: TextStyle(
        color: blackColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: whiteColor,
        hintText: 'Enter ${text}',
        hintStyle: TextStyle(
          color: greyColor,
          fontSize: 16,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please ${text} fields must not be empty';
        } else {
          return null;
        }
      },
    );
  }
}
