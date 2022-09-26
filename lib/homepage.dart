import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scan/app%20service/appconstants.dart';
import 'package:scan/app%20service/connexion.dart';
import 'package:scan/app%20service/futurebuilderconnexion.dart';
import 'package:scan/app%20service/loginservice.dart';
import 'package:http/http.dart' as http;
import 'package:scan/classes/etudiant.dart';
import 'package:scan/classes/examen.dart';
import 'package:scan/classes/local.dart';
import 'package:scan/classes/module.dart';
import 'package:scan/classes/professeur.dart';
import 'package:scan/etudiantsliste.dart';
import 'package:scan/scannedetudiant.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color bgColor = Colors.white;
  Examen? examen;
  String codeAppoge = "";
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String? token;

  String _getTimeStringFromDateTime(DateTime datetime) {
    return datetime.toString().split(' ')[1].substring(0, 8);
  }

  _scanneCarte() async {
    Connexion connexion = Connexion();
    token = await LoginService().getToken();
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
    if (anExamen == null || anExamen.id != examen!.id) {
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

  Future<dynamic> _getExamen() async {
    Connexion connexion = Connexion();
    String? token = await LoginService().getToken();
    if (token != null) {
      http.Response response =
          await connexion.getData("examensurveillance/$token/getexamen");
      if (kDebugMode) {
        print("**********************  ${response.body}  ********************");
      }
      dynamic examenMap = jsonDecode(response.body);
      if (kDebugMode) {
        print("---------     $examenMap     ----------");
      }
      examen = Examen.fromMap(examenMap);
      return response.body;
    } else {
      return "token error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderConnexion(_getExamen(), (context, data) {
      return Scaffold(
        body: SafeArea(
          child: Column(children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EtudiantsList()));
                    },
                    icon: const Icon(Icons.list))
              ],
            ),
            const Text("examen home page"),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "temps passé",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: Stream.periodic(const Duration(seconds: 1)),
              builder: (context, snapshot) {
                Duration passedTime = DateTime.now().difference(
                    DateTime.parse('${examen!.date} ${examen!.time}'));
                return Center(
                  child: Text(
                    _getTimeStringFromDateTime(
                        DateTime.fromMillisecondsSinceEpoch(
                            passedTime.inMilliseconds)),
                    style:
                        const TextStyle(color: Colors.orange, fontSize: 24.0),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "module: ${examen!.module.name}",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "filière: ${examen!.module.filiere.shortName}",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "local: ${examen!.local.name}",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _key,
              child: Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              codeAppoge = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vueiller entrez un appoge valide';
                              }
                              return null;
                            },
                            cursorColor: AppConstants.BACKGROUND_APP,
                            maxLength: 20,
                            decoration: const InputDecoration(
                              labelText: 'Code Appoge',
                              labelStyle: TextStyle(
                                color: Color(0xFF6200EE),
                                fontWeight: FontWeight.bold,
                              ),
                              helperText: 'sur la carte d\'étudiant',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppConstants.BACKGROUND_APP,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text("scanner"),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          _scanneCarte();
                        }
                      },
                      child: const Text("Valider"),
                    )
                  ],
                ),
              ),
            )
          ]),
        ),
      );
    }, bgColor);
  }
}
