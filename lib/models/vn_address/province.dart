
class Province {
  late String idProvince;
  late String name;

  Province({required this.idProvince, required this.name});

  Province.fromJson(Map<String, dynamic> json) {
    idProvince = json['idProvince'];
    name = json['name'];
  }
}