import 'package:asky/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asky/widgets/styled_button.dart';

class ChooseRequestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Do que você precisa?", // Displaying the request ID
                  style: GoogleFonts.notoSans(
                    textStyle: Theme.of(context).textTheme.displayLarge,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StyledButton(
                        text: "Medicamentos",
                        buttonType: ButtonType.optional,
                        onPressed: () async {
                          Navigator.of(context).pushNamed(
                            '/medicine',
                          );
                        },
                      ),
                      SizedBox(height: 30),
                      StyledButton(
                        text: "Materiais",
                        buttonType: ButtonType.optional,
                        onPressed: () async {
                          Navigator.of(context).pushNamed(
                            '/material',
                          );
                        },
                      ),
                      SizedBox(height: 30),
                      StyledButton(
                        text: "Assistência",
                        buttonType: ButtonType.optional,
                        onPressed: () async {
                          Navigator.of(context).pushNamed(
                            '/assistance',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ]),
        ));
  }
}
