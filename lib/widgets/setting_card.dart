import 'package:flutter/material.dart';

class SettingCard extends StatelessWidget {
  final String labelText;
  final List<Widget> children;

  const SettingCard({
    required this.labelText,
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(labelText),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(children: children),
            ),
          ],
        ),
      ),
    );
  }
}
