import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:asky/stores/pyxis_store.dart'; // Import the store

class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;
  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Escaneie o QR Code do Pyxis',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    final pyxisStore = context.read<PyxisStore>(); // Get the store instance
    if (barcodes.barcodes.isNotEmpty && mounted) {
      final barcodeValue =
          barcodes.barcodes.firstOrNull?.displayValue != null
            ? barcodes.barcodes.firstOrNull
            : null;
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull?.displayValue != null
            ? barcodes.barcodes.firstOrNull
            : null;
      });

      try {
        // Parse the barcode value as JSON
        print('OIIIIIIIIIII!!!!!!!');
        print(barcodeValue);
        print(barcodeValue?.displayValue);
        final Map<String, dynamic> barcodeJson = jsonDecode(_barcode?.displayValue ?? '');
        print(barcodeJson);
        final pyxisId = barcodeJson[
            'dispenser_id']; // Assuming 'pyxisId' is the key you are looking for

        if (pyxisId != null) {
          pyxisStore.setCurrentPyxisId(
              pyxisId); // Set the currentPyxisId in the store
          _controller.stop(); // Stop the scanner before navigating
          Navigator.pushNamed(
            context,
            '/medicine',
          ).then((_) {
            // Restart the scanner when coming back
            _controller.start();
          });
        } else {
          // Handle the case where 'pyxisId' is not present in the JSON
          print('pyxisId not found in the barcode JSON');
        }
      } catch (e) {
        // Handle JSON parsing error
        print('Error parsing JSON from barcode: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear Pyxis')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _handleBarcode,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                ],
              ),
            ),
          ),
          Observer(
            builder: (_) {
              final pyxisStore =
                  context.watch<PyxisStore>(); // Watch the store for changes
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Text(
                    'Barcode reading status: ${_barcode}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
