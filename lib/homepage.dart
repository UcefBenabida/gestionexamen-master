import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scan/app%20service/appconstants.dart';
import 'package:scan/app%20service/connexion.dart';
import 'package:scan/app%20service/futurebuilderconnexion.dart';
import 'package:scan/app%20service/loginservice.dart';
import 'package:http/http.dart' as http;
import 'package:scan/cartescanner.dart';
import 'package:scan/classes/etudiant.dart';
import 'package:scan/classes/examen.dart';
import 'package:scan/etudiantsliste.dart';
import 'package:scan/loginscreen.dart';
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
  int presences = 0;
  int absences = 0;
  int total = 0;
  bool notExistantEtudiant = false;
  AutovalidateMode autovalidateForm = AutovalidateMode.disabled;

  _getEtudiants(Connexion connexion, String tokener) async {
    total = 0;
    presences = 0;
    absences = 0;
    http.Response response = await connexion
        .getData("examensurveillance/$tokener/getallexamensurveillances");
    if (kDebugMode) {
      print(
          "***********getallexamensurveillances***********  ${response.body}  ********************");
    }
    dynamic listStus = jsonDecode(response.body);
    if (kDebugMode) {
      print("---------     $listStus     ----------");
    }

    for (dynamic etudiantMap in listStus) {
      total += 1;
      if (etudiantMap['presence'] == "P") {
        presences += 1;
      } else {
        absences += 1;
      }
    }
  }

  String _getTimeStringFromDateTime(DateTime datetime) {
    return datetime.toString().split(' ')[1].substring(0, 8);
  }

  _scanneCarte() async {
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
      if (anExamen == null || anExamen.id != examen!.id) {
        isNotTheSameExamen = true;
      }
      if (asMap['etudiant'] != null) {
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
        ).then((value) => setState(
              () {},
            ));
      } else {
        if (mounted) {
          setState(() {
            notExistantEtudiant = true;
            autovalidateForm = AutovalidateMode.always;
          });
        }
      }
    }
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
      if (examen != null) {
        await _getEtudiants(connexion, token);
      }
      return response.body;
    } else {
      return "token error";
    }
  }

  _logout() async {
    LoginService loginService = LoginService();
    bool test = await loginService.removeToken();
    if (test) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderConnexion(_getExamen(), (context, data) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.APP_NAME),
        ),
        body: SafeArea(
          child: Column(children: [
            Expanded(
                child: ListView(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      iconSize: 45,
                      onPressed: () {
                        _logout();
                      },
                      icon: const Icon(Icons.logout_sharp),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      iconSize: 45,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EtudiantsList()));
                      },
                      icon: const Icon(Icons.list_alt_rounded),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    "temps passé",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
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
                        style: const TextStyle(
                            color: Colors.orange, fontSize: 24.0),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "module: ${examen!.module.name}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    "filière: ${examen!.module.filiere.shortName}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    "local: ${examen!.local.name}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _key,
                  autovalidateMode: autovalidateForm,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 250,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                prefixIconColor: Colors.black87,
                                border: OutlineInputBorder(),
                                hintText: 'Code Appogé ',
                              ),
                              onChanged: (value) {
                                codeAppoge = value;
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    notExistantEtudiant) {
                                  if (notExistantEtudiant) {
                                    notExistantEtudiant = false;
                                    autovalidateForm =
                                        AutovalidateMode.disabled;
                                    return 'cet étudiant n\'existe pas';
                                  }
                                  return 'Vueiller entrez un appoge valide';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                            iconSize: 43,
                            icon: const Icon(
                              Icons.qr_code_scanner,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CarteScanner(examen!)));
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            _scanneCarte();
                          }
                        },
                        child: const Text("Valider"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "nombre total d\'étudiants: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      total.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "présence: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      presences.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "absence: ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      absences.toString(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            )),
          ]),
        ),
      );
    }, bgColor);
  }
}
