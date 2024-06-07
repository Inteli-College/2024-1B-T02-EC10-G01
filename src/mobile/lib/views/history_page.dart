import 'package:flutter/material.dart';
import 'package:asky/widgets/last_solicitation_card.dart';
import 'package:asky/api/request_medicine_api.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final RequestMedicineApi api = RequestMedicineApi();
  Future? _lastRequest;

  @override
  void initState() {
    super.initState();
    _lastRequest = api.getLastRequest();
  }

  Future<void> _refreshData() async {
    setState(() {
      _lastRequest = api.getLastRequest();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
              "Solicitar um medicamento",
              style: GoogleFonts.notoSans(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
              ],
            ),
          ),
      ),
    );
  }
}
