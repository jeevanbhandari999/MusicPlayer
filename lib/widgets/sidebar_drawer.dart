import 'package:flutter/material.dart';
import 'package:music_player/data/sidebar_drawer_item_data.dart';
import 'package:music_player/widgets/sidebar_drawer_item.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarDrawer extends StatelessWidget {
  const SidebarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/music.webp'),
                fit: BoxFit.cover,
                opacity: 0.6,
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Music Player',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          for (final item in availableSidebarDrawerItems)
            SidebarDrawerItem(
              title: item.title,
              icon: item.icon,
              route: item.route,
              widget: item.widget,
            ),
        ],
      ),
    );
  }
}
