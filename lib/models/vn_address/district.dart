import 'commune.dart';

class District {
  late String idProvince;
  late String idDistrict;
  late String name;

  District({required this.idProvince, required this.idDistrict, required this.name});

  District.fromJson(Map<String, dynamic> json) {
    idProvince = json['idProvince'];
    idDistrict = json['idDistrict'];
    name = json['name'];
  }
}