import 'package:flutter/material.dart';

import '../../core/constants/api_constants.dart';
import '../../models/qr_model.dart';
import '../../services/qr_service.dart';

class QRScreen extends StatefulWidget {
  final int listingId;

  const QRScreen({
    super.key,
    required this.listingId,
  });

  @override
  State<QRScreen> createState() =>
      _QRScreenState();
}

class _QRScreenState
    extends State<QRScreen> {

  QRModel? qr;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadQR();
  }

  Future<void> loadQR() async {
    try {
      final response =
          await QRService().generateQR(
        widget.listingId,
      );

      setState(() {
        qr = QRModel.fromJson(
          response.data,
        );

        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Listing QR Codes",
        ),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding:
                  const EdgeInsets.all(
                20,
              ),
              child: Column(
                children: [

                  const Text(
                    "ENTRY QR",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Image.network(
                    "${ApiConstants.baseUrl}${qr!.entryQrPath}",
                    height: 250,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  const Text(
                    "EXIT QR",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Image.network(
                    "${ApiConstants.baseUrl}${qr!.exitQrPath}",
                    height: 250,
                  ),
                ],
              ),
            ),
    );
  }
}