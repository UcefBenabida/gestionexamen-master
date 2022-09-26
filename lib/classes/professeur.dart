class Professeur {
  int id;
  String firstName;
  String lastName;
  String cin;
  Professeur(this.id, this.firstName, this.lastName, this.cin);
  factory Professeur.fromMap(Map<String, dynamic> asMap) {
    return Professeur(asMap['id'] as int, asMap['firstName'], asMap['lastName'],
        asMap['cin']);
  }
}
