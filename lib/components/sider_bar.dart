// 写一个组件
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import '../utils/screen.dart';
import '../store/theme.dart';

class SiderBarItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool selected;
  final Function? onTap;

  const SiderBarItem(this.icon, this.name, {super.key, required this.selected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final constTheme = Theme.of(context).extension<ExtColors>()!;
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        width: 52.w,
        height: 52.w,
        padding: EdgeInsets.only(top: 8.w),
        decoration: BoxDecoration(
          color: selected ? constTheme.sidebarText.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6.w),
        ),
        margin: EdgeInsets.only(bottom: 5.w),
        child: Column(
          children: [
            Icon(
              icon,
              color: constTheme.sidebarText,
              size: 20.w,
            ),
            SizedBox(height: 4.w),
            Text(
              name,
              style: TextStyle(
                color: constTheme.sidebarText,
                fontSize: 10.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
