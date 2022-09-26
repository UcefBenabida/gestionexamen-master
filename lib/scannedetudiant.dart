import 'package:flutter/material.dart';
import 'package:scan/app%20service/connexion.dart';
import 'package:scan/app%20service/stringservice.dart';
import 'package:scan/classes/etudiant.dart';
import 'package:scan/classes/examen.dart';

// ignore: must_be_immutable
class ScannedEtudiant extends StatefulWidget {
  Etudiant etudiant;
  Examen? examen;
  bool alreadyScanned;
  bool isNotTheSameExamen;
  String token;
  // ignore: use_key_in_widget_constructors
  ScannedEtudiant(
      this.etudiant, this.token, this.alreadyScanned, this.isNotTheSameExamen,
      [this.examen]);
  @override
  State<StatefulWidget> createState() {
    return _ScannedEtudiantState();
  }
}

class _ScannedEtudiantState extends State<ScannedEtudiant> {
  double imageSize = 140;
  Color backGroundColor = Colors.white;
  double imageBorderZise = 10;
  Connexion connexion = Connexion();
  String message = "";

  @override
  Widget build(BuildContext context) {
    if (!widget.isNotTheSameExamen) {
      if (widget.alreadyScanned) {
        backGroundColor = Colors.yellow;
        message = "cette carte est déjas scannée";
      } else {
        backGroundColor = Colors.green;
        message = "vérifiée";
      }
    } else {
      backGroundColor = Colors.red;
      if (widget.examen != null) {
        message = "cet étudiant a un autre examain";
      } else {
        message = "étudiant intrus";
      }
    }
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Column(children: [
        Expanded(
          child: ListView(children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      color: Colors.blueGrey,
                      height: 160,
                      width: double.infinity,
                    ),
                    Container(
                      color: backGroundColor,
                      width: double.infinity,
                      height: 85,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              height: imageSize + imageBorderZise,
                              width: imageSize + imageBorderZise,
                              color: backGroundColor,
                            ),
                          ),
                          Positioned(
                            left: imageBorderZise / 2,
                            top: imageBorderZise / 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Builder(builder: (context) {
                                if (widget.etudiant.image is String) {
                                  return Image.network(
                                    '${Connexion.apiUrl}examensurveillance/${widget.token}/showimage/${widget.etudiant.image}',
                                    height: imageSize,
                                    width: imageSize,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/images/profile_image.jpg',
                                        height: imageSize,
                                        width: imageSize,
                                      );
                                    },
                                  );
                                } else {
                                  return Image.asset(
                                    'assets/image/profile_image.jpg',
                                    height: imageSize,
                                    width: imageSize,
                                  );
                                }
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${StringService.capitalizeString(widget.etudiant.firstName)} ${StringService.capitalizeString(widget.etudiant.lastName)}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 109, 105, 105),
                      fontWeight: FontWeight.normal,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(message),
            ),
            const SizedBox(
              height: 20,
            ),
            Builder(builder: (context) {
              if (widget.examen != null) {
                return Column(
                  children: [
                    Text(
                      "module: ${widget.examen!.module.name}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "filière: ${widget.examen!.module.filiere.shortName}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "local: ${widget.examen!.local.name}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            }),
          ]),
        ),
      ]),
    );
  }
}
