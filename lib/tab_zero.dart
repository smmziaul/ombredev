import 'package:flutter/material.dart';
import 'main.dart';
import 'common_widgets.dart';

// dummy page 0
class TabZero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyParent(
      meText: "You're viewing page 0",
      iconData: Icons.people_outline,
    );
  }
}