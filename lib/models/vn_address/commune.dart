class Commune {
  late String idDistrict;
  late String idCommune;
  late String name;

  Commune({required this.idDistrict, required this.idCommune, required this.name});

  Commune.fromJson(Map<String, dynamic> json) {
    idDistrict = json['idDistrict'];
    idCommune = json['idCommune'];
    name = json['name'];
  }

  @override
  String toString() {
    return 'Commune{name: $name}';
  }
}