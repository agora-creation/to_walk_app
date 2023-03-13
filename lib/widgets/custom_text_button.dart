import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String? labelText;
  final Color? backgroundColor;
  final Function()? onPressed;

  const CustomTextButton({
    this.labelText,
    this.backgroundColor,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      ),
      child: Text(
        labelText ?? '',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
