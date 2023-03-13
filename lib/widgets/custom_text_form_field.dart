import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final IconData? iconData;

  const CustomTextFormField({
    this.controller,
    this.obscureText,
    this.keyboardType,
    this.iconData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      maxLines: 1,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 16,
      ),
      cursorColor: const Color(0xFFEEEEEE),
      decoration: InputDecoration(
        fillColor: const Color(0xFFEEEEEE),
        prefixIcon: iconData != null
            ? Icon(
                iconData,
                size: 18,
                color: const Color(0xFF333333),
              )
            : null,
        filled: true,
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusColor: const Color(0xFF333333),
      ),
    );
  }
}
