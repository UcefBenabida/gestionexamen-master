class Filiere {
  int id;
  String name;
  String shortName;
  Filiere(this.id, this.name, this.shortName);
  factory Filiere.fromMap(Map<String, dynamic> asMap) {
    return Filiere(asMap['id'] as int, asMap['name'], asMap['short_name']);
  }
}
