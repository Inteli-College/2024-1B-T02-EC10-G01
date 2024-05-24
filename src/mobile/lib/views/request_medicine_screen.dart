import 'package:flutter/material.dart';
import 'package:asky/api/authentication_api.dart';
import 'package:asky/views/history_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class RequestMedicine extends StatefulWidget {
  RequestMedicine({Key? key}) : super(key: key);

  @override
  State<RequestMedicine> createState() => _RequestMedicineState();
}

class _RequestMedicineState extends State<RequestMedicine> {
  int _selectedIndex = 0;
  final auth = AuthenticationApi();
  bool isEmergency = false;  // false para Normal, true para Emergência
  String dropdownValue = 'Amoxicilina';  // Default value

  List<String> medicines = [
    "Amoxicilina",
    "Paracetamol",
    "Ibuprofeno",
    "Dipirona",
    "Ciprofloxacino",
    "Azitromicina",
    "Losartana",
    "Atenolol",
    "Metformina",
    "Sertralina"
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final int? notificationIndex = ModalRoute.of(context)?.settings.arguments as int?;
    if (notificationIndex != null) {
      setState(() {
        _selectedIndex = notificationIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ASKY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF1A365D),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 34),
            Text(
              'Selecione o medicamento',
              style: TextStyle(fontSize: 24),
            ),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: medicines.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text('Normal'),
                  selected: !isEmergency,
                  onSelected: (value) {
                    setState(() {
                      isEmergency = !value;
                    });
                  },
                ),
                SizedBox(width: 20),
                ChoiceChip(
                  label: Text('Emergência'),
                  selected: isEmergency,
                  onSelected: (value) {
                    setState(() {
                      isEmergency = value;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirmação'),
                    content: Text('Medicamento selecionado: $dropdownValue\nEmergência: $isEmergency'),
                  ),
                );
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavBar(),
    );
  }

  Widget buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: const [
              GButton(icon: Icons.home_filled, text: 'Home'),
              GButton(icon: Icons.list, text: 'Histórico'),
              GButton(icon: Icons.person)
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}