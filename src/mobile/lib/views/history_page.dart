import 'package:asky/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:asky/widgets/styled_button.dart';
import 'package:asky/api/history_api.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Map requests = {};

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  void fetchRequests() async {
    var fetchedRequests = await HistoryApi.getHistory();
    print(fetchedRequests);
    setState(() {
      requests = fetchedRequests;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Todas as solicitações",
            style: GoogleFonts.notoSans(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                var request = requests['pending'][index];
                // Example of displaying request data. Modify as necessary.
                return ListTile(
                  title: Text("Request ID: ${request['id']}"),
                  subtitle: Text("Status: ${request['status']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
