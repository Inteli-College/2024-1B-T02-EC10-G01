import 'package:flutter/material.dart';

class AssistanceScreen extends StatefulWidget {
  @override
  _AssistanceScreenState createState() => _AssistanceScreenState();
}

class _AssistanceScreenState extends State<AssistanceScreen> {
  String _selectedAssistanceType = 'Manutenção';
  final List<String> _assistanceTypes = [
    'Manutenção',
    'Solicitação',
    'Divergencia',
  ];
  final TextEditingController _detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assistência', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xff1A365D),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Detalhes',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1A365D))),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Enfermeiro', 'Enfermeiro'),
                  Divider(color: Colors.grey.shade300),
                  _buildDetailRow('Data', 'Data'),
                  Divider(color: Colors.grey.shade300),
                  _buildDetailRow('Local', 'Andar | Pyxis'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text('Qual tipo de assistência precisa?',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1A365D))),
            SizedBox(height: 8),
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedAssistanceType,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAssistanceType = newValue!;
                });
              },
              items: _assistanceTypes
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(color: Colors.black)),
                );
              }).toList(),
              dropdownColor: Colors.white,
            ),
            SizedBox(height: 16),
            Text('Detalhes',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff1A365D))),
            SizedBox(height: 8),
            TextField(
              controller: _detailsController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escreva o problema encontrado',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Aqui você pode adicionar a lógica para enviar os detalhes da assistência
                },
                child: Text('Confirmar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1A365D), // Cor do botão
                  foregroundColor: Colors.white, // Cor do texto do botão
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}
