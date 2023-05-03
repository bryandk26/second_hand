import 'package:flutter/material.dart';
import 'package:second_chance/theme.dart';

class TextFormGlobal extends StatelessWidget {
  TextFormGlobal({
    super.key,
    this.controller,
    required this.text,
    required this.textInputType,
    required this.obsecure,
    this.validator,
    this.onChanged,
  });
  final TextEditingController? controller;
  final String text;
  final TextInputType textInputType;
  final bool obsecure;
  final String? Function(String?)? validator;
  final String? Function(String)? onChanged;

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
      validator: validator,
    );
  }
}
