import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scan/app%20service/appconstants.dart';
import 'package:scan/app%20service/connexion.dart';
import 'package:scan/app%20service/futurebuilderconnexion.dart';
import 'package:http/http.dart' as http;
import 'package:scan/app%20service/loginservice.dart';
import 'package:scan/classes/etudiant.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class EtudiantsList extends StatelessWidget {
  Color bgColor = Colors.white;
  List<Etudiant> etudiantsList = [];
  List<String> status = [];

  Future<dynamic> _getEtudiants() async {
    Connexion connexion = Connexion();
    String? token = await LoginService().getToken();
    if (token != null) {
      http.Response response = await connexion
          .getData("examensurveillance/$token/getallexamensurveillances");
      if (kDebugMode) {
        print("**********************  ${response.body}  ********************");
      }
      //dynamic listEtd = jsonDecode(response.body);
      dynamic listStus = jsonDecode(response.body);
      if (kDebugMode) {
        print("---------     $listStus     ----------");
      }
      for (dynamic etudiantMap in listStus) {
        etudiantsList.add(Etudiant.fromMap(etudiantMap['etudiant']));
        status.add(etudiantMap['presence']);
      }
      return response.body;
    } else {
      return "token error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderConnexion(_getEtudiants(), (context, data) {
      List<DataRow> list = [];
      int i = 0;
      Color color = Colors.red;
      for (Etudiant etudiant in etudiantsList) {
        if (status[i] == "P") {
          color = Colors.green;
        } else {
          color = Colors.red;
        }
        list.add(
          DataRow(
            cells: <DataCell>[
              DataCell(Text(
                etudiant.firstName,
                textAlign: TextAlign.center,
              )),
              DataCell(Text(
                etudiant.lastName,
                textAlign: TextAlign.center,
              )),
              DataCell(Text(
                etudiant.codeAppoge,
                textAlign: TextAlign.center,
              )),
              DataCell(Text(
                status[i],
                textAlign: TextAlign.center,
                style: TextStyle(color: color),
              )),
            ],
          ),
        );
        i++;
      }
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(AppConstants.APP_NAME),
        ),
        body: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "la liste des étudiants",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      border: TableBorder.all(
                        width: 1.0,
                        color: Colors.black,
                      ),
                      columnSpacing: 20,
                      horizontalMargin: 10,
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.white54),
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Nom',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Prènom',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Code Appogé',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Expanded(
                            child: Text(
                              'Status',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: list,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      );
    }, bgColor);
  }
}
