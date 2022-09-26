import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan/app%20service/connexion.dart';
import 'package:scan/app%20service/loginservice.dart';
import 'package:scan/app%20service/soundservice.dart';
import 'package:http/http.dart' as http;
import 'package:scan/homepage.dart';

class ScannerWidget extends StatefulWidget {
  const ScannerWidget({Key? key}) : super(key: key);

  @override
  createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  bool scanned = false;
  int ifTokenIsValidated = 0;
  MobileScannerController cameraController = MobileScannerController();

  _validateToken(String token) async {
    Connexion connexion = Connexion();
    http.Response response =
        await connexion.getData("examensurveillance/$token/validatetoken");
    if (kDebugMode) {
      print("********************  ${response.body}  *********************");
    }
    if (response.body == "token is valid.") {
      LoginService loginService = LoginService();
      bool test = await loginService.setToken(token);
      if (test) {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
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
                  _validateToken(code);
                  if (kDebugMode) {
                    print("********************  $code  *********************");
                  }
                }
              }
            }));
  }
}
