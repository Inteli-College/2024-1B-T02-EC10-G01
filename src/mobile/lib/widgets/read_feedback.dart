import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:asky/api/authentication_api.dart';
import 'package:asky/api/feedback_api.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadFeedbackWidget extends StatelessWidget {
  String? feedbackReceived;
  final String? typeUser;
  final String? typeRequest;
  final int? requestId;
  final String? phoneNumber;
  bool isReadOnly;

  final AuthenticationApi auth = AuthenticationApi();

  ReadFeedbackWidget(
      {Key? key,
      required this.feedbackReceived,
      this.isReadOnly = true,
      this.typeUser,
      this.typeRequest,
      this.requestId,
      this.phoneNumber});

  void _launchWhatsApp() async {
    final url = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    } // Replace with actual phone number
  }

  @override
  Widget build(BuildContext context) {
    final api;

    if (typeUser == 'agent') {
      isReadOnly = false;
    } else {
      isReadOnly = true;
    }

    switch (typeRequest) {
      case 'material':
        api = MaterialFeedbackRequest();
        break;
      case 'assistance':
        api = AssistanceFeedbackRequest(); // Make sure to implement this API
        break;
      default:
        api = MedicineFeedbackRequest();
    }

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
                onPressed: () {
                  if (phoneNumber == null) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title:
                            Text('Este número de telefone não está disponível'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    _launchWhatsApp();
                  }
                },
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
            onChanged: (value) {
              feedbackReceived =
                  value; // Atualiza o valor do texto conforme o usuário digita
            },
            controller: TextEditingController(text: feedbackReceived),
            textInputAction: TextInputAction.done,
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              api.createFeedback(requestId, feedbackReceived);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Write your feedback here...',
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            readOnly: isReadOnly, // Controlled by the isReadOnly flag
          ),
        ),
      ],
    );
  }
}
