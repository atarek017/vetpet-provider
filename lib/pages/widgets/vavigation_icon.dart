import 'package:flutter/material.dart';

class NavigationIcon extends StatelessWidget {
  final IconData icon;

  NavigationIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Theme.of(context).primaryColor,
    );
  }
}
