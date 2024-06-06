import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asky/stores/pyxis_store.dart'; // Import the store

class RequestMedicine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pyxisStore = context.watch<PyxisStore>(); // Watch the store for changes

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar medicamento'),
      ),
      body: Center(
        child: Text(
          'Current Pyxis ID: ${pyxisStore.currentPyxisId}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
