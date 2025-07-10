import 'package:flutter/material.dart';
import 'package:music_player/model/sidebar_drawer_model.dart';
import 'package:music_player/routes/routes_info.dart';
import 'package:music_player/screens/sleep_timer.dart';
import 'package:music_player/screens/settings.dart';

var availableSidebarDrawerItems = [
  SidebarDrawerModel(title: 'Equalizer', icon: Icons.equalizer_rounded),
  SidebarDrawerModel(title: 'Shuffle All', icon: Icons.shuffle),
  SidebarDrawerModel(title: 'Themes', icon: Icons.image_search),
  SidebarDrawerModel(
    title: 'Sleep Timer',
    icon: Icons.notifications_active,
    route: RoutesInfo.getSleepTimerPage(),
    widget: SleepTimer(),
  ),
  SidebarDrawerModel(
    title: 'Settings',
    icon: Icons.settings,
    route: RoutesInfo.getSettingsPage(),
    widget: SettingsPage(),
  ),
  SidebarDrawerModel(title: 'Quit', icon: Icons.logout),
];
