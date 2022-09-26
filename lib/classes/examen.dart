import 'package:scan/classes/local.dart';
import 'package:scan/classes/module.dart';
import 'package:scan/classes/professeur.dart';

class Examen {
  int id;
  String token;
  String date;
  String time;
  int period;
  Local local;
  Module module;
  List<Professeur> surveillantsProfs;
  Examen(this.id, this.token, this.date, this.time, this.period, this.local,
      this.module, this.surveillantsProfs);
  factory Examen.fromMap(Map<String, dynamic> examenMap) {
    List<Professeur> profs = [];
    if (examenMap['examen_survaillances'] != null) {
      for (dynamic map in examenMap['examen_survaillances']) {
        profs.add(Professeur.fromMap(map));
      }
    }

    return Examen(
        examenMap['id'] as int,
        examenMap['token'],
        examenMap['date'],
        examenMap['time'],
        examenMap['period'] as int,
        Local.fromMap(examenMap['local']),
        Module.fromMap(examenMap['module']),
        profs);
  }
}
