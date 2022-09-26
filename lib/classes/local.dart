class Local {
  int id;
  String name;
  int capacity;
  Local(this.id, this.name, this.capacity);
  factory Local.fromMap(Map<String, dynamic> asMap) {
    return Local(asMap['id'] as int, asMap['name'], asMap['capacity'] as int);
  }
}
