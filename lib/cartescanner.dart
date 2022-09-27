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
class CarteScanner extends StatefulWidget {
  Examen examen;
  // ignore: use_key_in_widget_constructors
  CarteScanner(this.examen);

  @override
  createState() => _CarteScannerState();
}

class _CarteScannerState extends State<CarteScanner> {
  bool scanned = false;
  int ifTokenIsValidated = 0;
  MobileScannerController cameraController = MobileScannerController();
  String? token;

  _scnneEtudiantCarte(String codeAppoge) async {
    Connexion connexion = Connexion();
    token = await LoginService().getToken();
    if (token != null) {
      http.Response response = await connexion
          .getData("examensurveillance/$token/scanneetudiantcarte/$codeAppoge");
      if (kDebugMode) {
        print("******************  ${response.body}  **************");
      }
      dynamic asMap = jsonDecode(response.body);
      Examen? anExamen;
      if (asMap['examen'] != null) {
        anExamen = Examen.fromMap(asMap['examen']);
      }
      bool isNotTheSameExamen = false;
      if (anExamen == null || anExamen.id != widget.examen!.id) {
        isNotTheSameExamen = true;
      }
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScannedEtudiant(
                Etudiant.fromMap(asMap['etudiant']),
                token!,
                asMap['already_scanned'],
                isNotTheSameExamen,
                anExamen)),
      );
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
