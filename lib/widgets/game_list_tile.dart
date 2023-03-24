import 'package:flutter/material.dart';

class GameListTile extends StatelessWidget {
  final String labelText;
  final Function()? onTap;

  const GameListTile({
    required this.labelText,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(
              labelText,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
