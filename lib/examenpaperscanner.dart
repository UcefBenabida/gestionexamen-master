import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan/app%20service/connexion.dart';
import 'package:scan/app%20service/loginservice.dart';
import 'package:scan/app%20service/soundservice.dart';
import 'package:http/http.dart' as http;
import 'package:scan/classes/etudiant.dart';
import 'package:scan/classes/examen.dart';
import 'package:scan/scannedetudiant.dart';

// ignore: must_be_immutable
class ExamenPaperScanner extends StatefulWidget {
  Examen examen;
  // ignore: use_key_in_widget_constructors
  ExamenPaperScanner(this.examen);

  @override
  createState() => _ExamenPaperScannerState();
}

class _ExamenPaperScannerState extends State<ExamenPaperScanner> {
  bool scanned = false;
  int ifTokenIsValidated = 0;
  MobileScannerController cameraController = MobileScannerController();
  String? token;

  _scnneEtudiantCarte(String paper_token) async {
    Connexion connexion = Connexion();
    token = await LoginService().getToken();
    if (token != null) {
      http.Response response = await connexion
          .getData("examensurveillance/$token/scanneexamenpaper/$paper_token");
      if (kDebugMode) {
        print("******************  ${response.body}  **************");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: const Text('Mobile Scanner'),
          actions: [
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.grey);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.yellow);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.white,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: MobileScanner(
            allowDuplicates: false,
            controller: cameraController,
            onDetect: (barcode, args) {
              if (!scanned) {
                scanned = true;
                if (barcode.rawValue == null) {
                  debugPrint('Failed to scan Barcode');
                } else {
                  SoundService.playLocalSound("audios/beep.mp3");
                  final String code = barcode.rawValue!;
                  _scnneEtudiantCarte(code);
                  if (kDebugMode) {
                    print("********************  $code  *********************");
                  }
                }
              }
            }));
  }
}
