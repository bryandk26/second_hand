import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            blurRadius: 7,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller ?? null,
        keyboardType: textInputType,
        obscureText: obsecure,
        decoration: InputDecoration(
          hintText: text,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
          hintStyle: TextStyle(height: 1),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
