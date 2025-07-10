import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SidebarDrawerItem extends StatelessWidget {
  const SidebarDrawerItem({
    super.key,
    required this.title,
    required this.icon,
    this.route,
    this.widget,
  });
  final String title;
  final IconData icon;
  final String? route;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget != null) {
          Get.to(() => widget!);
        } else {
          null;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        margin: EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Icon(icon), SizedBox(width: 20), Text(title)],
        ),
      ),
    );
  }
}
