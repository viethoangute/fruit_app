import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:training_example/models/vn_address/district.dart';
import 'package:training_example/models/vn_address/province.dart';

import '../models/vn_address/commune.dart';

@singleton
class VNAddressRepository {
  final String dbPath = 'assets/data/db.json';

  Future<String> _loadAddressAsset() async {
    var rs = await rootBundle.loadString(dbPath);
    return rs;
  }

  Future<List<Province>> getAllProvinces() async {
    List<Province> provinces = [];
    String jsonString = await _loadAddressAsset();
    final jsonResponse = json.decode(jsonString);
    provinces = List<Province>.from(
        jsonResponse['province'].map((province) => Province.fromJson(province))
    );
    return provinces;
  }

  Future<List<District>> getDistrictsOfProvince({required String idProvince}) async {
    List<District> districts = [];
    String jsonString = await _loadAddressAsset();
    final jsonResponse = json.decode(jsonString);
    districts = List<District>.from(
        jsonResponse['district'].where((district) => district['idProvince'] == idProvince).map((x) => District.fromJson(x))
    );
    return districts;
  }

  Future<List<Commune>> getCommunesOfDistrict({required String idDistrict}) async {
    List<Commune> communes = [];
    String jsonString = await _loadAddressAsset();
    final jsonResponse = json.decode(jsonString);
    communes = List<Commune>.from(
        jsonResponse['commune'].where((commune) => commune['idDistrict'] == idDistrict).map((x) => Commune.fromJson(x))
    );
    return communes;
  }
}