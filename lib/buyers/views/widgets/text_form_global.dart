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
    this.enabled = true,
    this.maxLength,
    this.maxLines = 1,
  });
  final TextEditingController? controller;
  final String text;
  final TextInputType textInputType;
  final bool obsecure;
  final String? Function(String)? onChanged;
  final BuildContext context;
  final bool enabled;
  final int? maxLength;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller ?? null,
      keyboardType: textInputType,
      obscureText: obsecure,
      style: TextStyle(
        color: blackColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? whiteColor : lightGreyColor,
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
        ),
      ),
      maxLength: maxLength,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please this fields must not be empty';
        } else {
          return null;
        }
      },
    );
  }
}
