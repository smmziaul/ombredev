import 'package:flutter/material.dart';
import 'main.dart';
import 'common_widgets.dart';

// dummy page 2
class TabTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyParent(
      meText: "You're viewing page 2",
      iconData: Icons.featured_play_list,
    );
  }
}
