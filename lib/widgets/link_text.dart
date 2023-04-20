import 'package:flutter/material.dart';

class LinkText extends StatelessWidget {
  final String labelText;
  final Color labelColor;
  final Function()? onTap;

  const LinkText({
    required this.labelText,
    required this.labelColor,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        labelText,
        style: TextStyle(
          color: labelColor,
          fontSize: 18,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
