import 'package:flutter/material.dart';
 import 'package:font_awesome_flutter/font_awesome_flutter.dart';     


class ReadFeedbackWidget extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();

  ReadFeedbackWidget({Key? key}) : super(key: key);

  void _launchWhatsApp() async {
    const url = 'https://wa.me/1234567890'; // Replace with actual phone number
   
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Feedback',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.whatsapp),
                onPressed: _launchWhatsApp,
                color: Colors.green,
                iconSize: 30,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: TextField(
            controller: feedbackController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Write your feedback here...',
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ),
      ],
    );
  }
}
