import 'package:asky/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:asky/stores/pyxis_store.dart'; // Import the store
import 'package:asky/api/request_medicine_api.dart';
import 'package:asky/api/authentication_api.dart';


class GuideBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Define the size of the box
    double boxSize = size.width * 0.75; // Box takes up 75% of screen width

    // Calculate positions
    double left = (size.width - boxSize) / 2;
    double top = (size.height - boxSize) / 2;
    double right = left + boxSize;
    double bottom = top + boxSize;

    // Draw the edges of the box using short lines on each corner
    double edgeLength = 20; // Length of each edge line

    // Top-left corner
    canvas.drawLine(Offset(left, top), Offset(left + edgeLength, top), paint); // Horizontal line
    canvas.drawLine(Offset(left, top), Offset(left, top + edgeLength), paint); // Vertical line

    // Top-right corner
    canvas.drawLine(Offset(right, top), Offset(right - edgeLength, top), paint); // Horizontal line
    canvas.drawLine(Offset(right, top), Offset(right, top + edgeLength), paint); // Vertical line

    // Bottom-left corner
    canvas.drawLine(Offset(left, bottom), Offset(left + edgeLength, bottom), paint); // Horizontal line
    canvas.drawLine(Offset(left, bottom), Offset(left, bottom - edgeLength), paint); // Vertical line

    // Bottom-right corner
    canvas.drawLine(Offset(right, bottom), Offset(right - edgeLength, bottom), paint); // Horizontal line
    canvas.drawLine(Offset(right, bottom), Offset(right, bottom - edgeLength), paint); // Vertical line
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
class BarcodeScannerSimple extends StatefulWidget {
  const BarcodeScannerSimple({super.key});

  @override
  State<BarcodeScannerSimple> createState() => _BarcodeScannerSimpleState();
}

class _BarcodeScannerSimpleState extends State<BarcodeScannerSimple> {
  Barcode? _barcode;
  late MobileScannerController _controller;
  RequestMedicineApi requestMedicineApi = RequestMedicineApi();
  final AuthenticationApi auth = AuthenticationApi();

  @override
  void initState() {
    super.initState();
    _checkToken();
    _controller = MobileScannerController();
  }

  Future<void> _checkToken() async {
    if (!await auth.checkToken()) {
      print('Token is invalid');
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan the QR Code',
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) async {
    final pyxisStore = context.read<PyxisStore>(); // Get the store instance
    if (barcodes.barcodes.isNotEmpty && mounted) {
      final barcodeValue = barcodes.barcodes.firstOrNull;

      setState(() {
        _barcode = barcodeValue;
      });

      try {
        final Map<dynamic, dynamic> barcodeJson = jsonDecode(_barcode?.displayValue ?? '');
        final pyxisId = barcodeJson['dispenser_id'];

        if (pyxisId != null) {
          var pyxisData = await requestMedicineApi.getPyxisByPyxisId(pyxisId);
          if (pyxisData != null) {
            pyxisStore.setCurrentPyxisData(pyxisData);
            _controller.stop();
            Navigator.pushNamed(context, '/choose_request').then((_) {
              _controller.start();
            });
          } else {
            print('Failed to fetch pyxis data');
          }
        } else {
          print('pyxisId not found in the barcode JSON');
        }
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _handleBarcode,
          ),
          Align(
            alignment: Alignment.center,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
              painter: GuideBoxPainter(),
            ),
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
              final pyxisStore = context.watch<PyxisStore>();
              return Align(
                alignment: Alignment.topCenter,
                child: Container(),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}