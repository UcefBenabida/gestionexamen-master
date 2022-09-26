import 'package:scan/classes/filiere.dart';

class Module {
  int id;
  String name;
  String shortName;
  int semestre;
  Filiere filiere;
  Module(this.id, this.name, this.shortName, this.semestre, this.filiere);
  factory Module.fromMap(Map<String, dynamic> asMap) {
    return Module(
        asMap['id'] as int,
        asMap['name'],
        asMap['short_name'],
        int.parse(asMap['semestre'].toString()),
        Filiere.fromMap(asMap['filiere']));
  }
}
