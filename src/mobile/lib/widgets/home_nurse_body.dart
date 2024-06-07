// home_nurse_body.dart
import 'package:asky/widgets/last_solicitation_card.dart';
import 'package:flutter/material.dart';
import 'package:asky/api/request_medicine_api.dart'; // Assuming this contains the LastSolicitationApi class

class HomeNurseBody extends StatefulWidget {
  const HomeNurseBody({Key? key}) : super(key: key);

  @override
  _HomeNurseBodyState createState() => _HomeNurseBodyState();
}

class _HomeNurseBodyState extends State<HomeNurseBody> {
  final RequestMedicineApi api = RequestMedicineApi();

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/qrcode');
            },
            child: Icon(
              Icons.add,
              size: 100,
              color: Color(0xFF1A365D),
            ),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(
                  side: BorderSide(
                color: Color.fromRGBO(224, 224, 224, 0.25),
                width: 1, // Border thickness
              )),
              padding: EdgeInsets.all(50),
              backgroundColor: Colors.white,
              elevation: 4
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text(
              "Nova Solicitação",
              style: TextStyle(
                fontSize: 24.0,
                color: Color(0xFF1A365D),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Última solicitação:',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Color(0xFF1A365D),
                ),
              ),
            ),
          ),
          FutureBuilder(
              future: api.getLastRequest(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!;
                    return LastRequestCard(medicineName: data['medicine']['name'], currentStep: 1, totalSteps: 4);
                  } else {
                    return Text('Nenhuma solicitação encontrada');
                  }
                } else {
                  return CircularProgressIndicator();
                }
              }),
              
        ],
      ),
    ));
  }
}
