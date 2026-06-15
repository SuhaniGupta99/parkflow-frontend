import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../../providers/auth_provider.dart';
import '../../services/qr_scan_service.dart';

class QRScannerScreen extends StatefulWidget {
  final int bookingId;

  const QRScannerScreen({
    super.key,
    required this.bookingId,
  });

  @override
  State<QRScannerScreen> createState() =>
      _QRScannerScreenState();
}

class _QRScannerScreenState
    extends State<QRScannerScreen> {
  bool scanned = false;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception(
        "Location services are disabled",
      );
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission ==
            LocationPermission.denied ||
        permission ==
            LocationPermission.deniedForever) {
      throw Exception(
        "Location permission denied",
      );
    }

    return await Geolocator
        .getCurrentPosition();
  }

  Future<void> handleScan(
    String rawValue,
  ) async {
    try {
      final data =
          jsonDecode(rawValue);

      final token =
          Provider.of<AuthProvider>(
        context,
        listen: false,
      ).token!;

      final position =
          await getCurrentLocation();

      await QRScanService().scanQR(
        token: token,
        bookingId: widget.bookingId,
        listingId:
            data["listing_id"],
        qrType: data["type"],
        latitude:
            position.latitude,
        longitude:
            position.longitude,
      );

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
          title: const Text(
            "Success",
          ),
          content: const Text(
            "QR Scan Successful",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );

                Navigator.pop(
                  context,
                );
              },
              child: const Text(
                "OK",
              ),
            )
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
          title: const Text(
            "Error",
          ),
          content: Text(
            e.toString(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                );

                setState(() {
                  scanned = false;
                });
              },
              child: const Text(
                "OK",
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Scan QR",
        ),
      ),
      body: MobileScanner(
        onDetect: (capture) async {
          if (scanned) return;

          final barcode =
              capture.barcodes.first;

          final rawValue =
              barcode.rawValue;

          if (rawValue == null) {
            return;
          }

          scanned = true;

          await handleScan(
            rawValue,
          );
        },
      ),
    );
  }
}