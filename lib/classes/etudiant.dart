class Etudiant {
  int id;
  String firstName;
  String lastName;
  String codeAppoge;
  String? image;
  String cne;
  String cin;
  Etudiant(this.id, this.firstName, this.lastName, this.codeAppoge, this.cin,
      this.cne, this.image);
  factory Etudiant.fromMap(Map<String, dynamic> asMap) {
    return Etudiant(asMap['id'] as int, asMap['first_name'], asMap['last_name'],
        asMap['code_appoge'], asMap['cin'], asMap['cne'], asMap['image']);
  }
}
