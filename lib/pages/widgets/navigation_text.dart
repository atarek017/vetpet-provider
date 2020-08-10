import 'package:flutter/material.dart';

class NavigationText extends StatelessWidget {
  final String text;

  NavigationText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
