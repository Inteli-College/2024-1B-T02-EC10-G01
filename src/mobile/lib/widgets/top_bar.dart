import 'package:flutter/material.dart';
import 'package:asky/constants.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? backRoute;
  final bool showBackButton;  // New parameter to control back button visibility

  // Constructor with optional backRoute and showBackButton argument
  TopBar({this.backRoute, this.showBackButton = true});  // Default is to show the back button

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton ? Padding(  // Conditionally render the back button based on showBackButton
        padding: EdgeInsets.symmetric(vertical: 8.0),  // Maintained vertical padding
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (backRoute != null) {
              Navigator.pushNamed(context, backRoute!); // Navigate to provided route
            } else {
              Navigator.maybePop(context); // Default back action
            }
          },
        ),
      ) : null,  // If showBackButton is false, don't display the back button
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),  // Maintained vertical padding
        child: Center(
          child: Image.asset(
            'assets/logo.png',  // Ensure the logo path is correct
            height: 40,
          ),
        ),
      ),
      backgroundColor: Constants.askyBlue,
      actions: <Widget>[
        Opacity(
          opacity: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),  // Consistent vertical padding
            child: IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 16.0);  // Include extra height for padding
}
