import 'package:flutter/material.dart';
import 'package:asky/constants.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? backRoute;
  final bool showBackButton;  // New parameter to control back button visibility

  TopBar({this.backRoute, this.showBackButton = true});  // Default is to show the back button

  @override
  Widget build(BuildContext context) {
    print('TopBar: showBackButton: $showBackButton');
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),  // Add bottom padding here
      child: AppBar(
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
        ) : Opacity(
            opacity: 0.0,  // Invisible placeholder
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
            ),
          ),
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0),
          child: Center(
            child: Image.asset(
              'assets/logo.png',
              height: 40,
            ),
          ),
        ),
        backgroundColor: Constants.askyBlue,
        actions: <Widget>[
          Opacity(
            opacity: 0.0,  // Invisible placeholder on the right side to balance the title
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: IconButton(icon: Icon(Icons.arrow_back), onPressed: null),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 30.0); // Increase AppBar height to accommodate bottom padding
}
