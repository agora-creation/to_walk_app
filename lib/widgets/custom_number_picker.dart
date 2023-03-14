import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class CustomNumberPicker extends StatelessWidget {
  final int minValue;
  final int maxValue;
  final int value;
  final Function(int) onChanged;

  const CustomNumberPicker({
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black12),
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      child: NumberPicker(
        minValue: minValue,
        maxValue: maxValue,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
