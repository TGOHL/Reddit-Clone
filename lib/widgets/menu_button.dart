import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String label;
  final IconData iconData;
  final Function()? onTap;
  const MenuButton(
      {super.key, required this.label, required this.iconData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 14),
        child: Row(
          children: [Icon(iconData),const SizedBox(width: 6,),Text(label)],
        ),
      ),
    );
  }
}
