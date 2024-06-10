import 'package:asky/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class ChooseRequestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(

      ),
      body: Center(
        child: Text(
          'Hello, World!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      
    );
  }
}
