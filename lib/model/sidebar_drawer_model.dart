import 'package:flutter/material.dart';

class SidebarDrawerModel {
  const SidebarDrawerModel({
    required this.title,
    required this.icon,
    this.route,
    this.widget,
  });
  final String title;
  final IconData icon;
  final String? route;
  final Widget? widget;
}
