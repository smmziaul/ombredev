import 'package:flutter/material.dart';
import 'main.dart';
import 'common_widgets.dart';

// dummy page 1
class TabOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyParent(
      meText: "You're viewing page 1",
      iconData: Icons.add,
    );
  }
}
