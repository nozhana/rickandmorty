import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({super.key, this.title, this.actions, this.titleTextStyle});

  final Widget? title;
  final List<Widget>? actions;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title?.px4(),
      actions: actions,
      titleTextStyle: titleTextStyle,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 32);
}
