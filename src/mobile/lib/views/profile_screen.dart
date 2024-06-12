import 'package:asky/constants.dart';
import 'package:asky/widgets/history_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asky/api/history_api.dart';
import 'package:asky/api/authentication_api.dart'; // Import the Authentication API

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var auth = AuthenticationApi();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Profile Screen', style: GoogleFonts.lato(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                auth.signOut(); // Call the signOut method, no value expected
                Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
              },
              child: Text('Logout', style: GoogleFonts.lato(fontSize: 18)),
            ),
          ],
        ),
      );
  }
}
