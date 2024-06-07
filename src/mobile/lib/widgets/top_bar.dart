import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String imagePath = "assets/logo.png";


  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Image.asset(
          imagePath,
          width: 50,
          height: 50,
        ),
      ),
      backgroundColor: Color(0xFF1A365D),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
