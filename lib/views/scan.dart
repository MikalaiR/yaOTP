import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:yaotp/generated/l10n.dart';
import 'package:yaotp/models/securtotp.dart';

class QRScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  QRViewController controller;
  StreamSubscription subscription;

  final GlobalKey qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: () {
              controller.toggleFlash();
            },
          ),
          IconButton(
            icon: Icon(Icons.flip_camera_android),
            onPressed: () {
              controller.flipCamera();
            },
          )
        ],
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController _controller) {
    controller = _controller;
    subscription = controller.scannedDataStream.listen((scanData) async {
      try {
        final otp = SecurTOTP.fromUri(scanData);
        if (otp != null) {
          await subscription.cancel();
          subscription = null;

          controller.pauseCamera();

          Navigator.pop(context, otp);
        } else {
          showErrorSnackbar(S.of(context).wrongQrCodeFormat);
        }
      } on FormatException catch (e) {
        showErrorSnackbar(S.of(context).wrongQrCodeFormat);
      }
    });
  }

  void showErrorSnackbar(String err) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(err)));
  }

  @override
  void dispose() {
    subscription?.cancel();
    controller?.dispose();
    super.dispose();
  }
}
