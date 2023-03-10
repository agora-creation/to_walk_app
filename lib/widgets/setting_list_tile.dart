import 'package:flutter/material.dart';

class SettingListTile extends StatelessWidget {
  final String labelText;
  final IconData iconData;
  final Function()? onTap;

  const SettingListTile({
    required this.labelText,
    required this.iconData,
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
        trailing: Icon(
          iconData,
          color: Colors.cyan,
        ),
        onTap: onTap,
      ),
    );
  }
}
