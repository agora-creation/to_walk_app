import 'package:flutter/material.dart';

class SettingListTile extends StatelessWidget {
  final String labelText;
  final String? value;
  final Function()? onTap;

  const SettingListTile({
    required this.labelText,
    this.value,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      child: ListTile(
        title: Text(labelText),
        trailing: value == null
            ? const Icon(Icons.chevron_right, color: Colors.cyan)
            : Text(
                value ?? '',
                style: const TextStyle(color: Colors.black54),
              ),
        onTap: onTap,
      ),
    );
  }
}
