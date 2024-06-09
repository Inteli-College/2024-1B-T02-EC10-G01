import 'package:flutter/material.dart';
import 'package:asky/widgets/last_solicitation_card.dart';
import 'package:asky/api/request_medicine_api.dart';

class ChooseRequestBody extends StatefulWidget {
  const ChooseRequestBody({Key? key}) : super(key: key);

  @override
  _ChooseRequestBodyState createState() => _ChooseRequestBodyState();
}

class _ChooseRequestBodyState extends State<ChooseRequestBody> {
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

  Widget customButton(String title, String routeName) {
    return SizedBox(
      width: 300,  // Define a largura do botão
      height: 60,  // Define a altura do botão
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: () => Navigator.of(context).pushNamed(routeName),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text("O que você precisa?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          customButton('Medicamento', '/medicine'),
          SizedBox(height: 10),
          customButton('Material', '/material'),
          SizedBox(height: 10),
          customButton('Assistência', '/assistance'),
        ],
      ),
    );
  }
}