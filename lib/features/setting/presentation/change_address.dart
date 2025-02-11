import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:training_example/di/injection.dart';
import 'package:training_example/features/home/bloc/user_info_bloc/user_info_bloc.dart';
import 'package:training_example/features/home/bloc/user_info_bloc/user_info_event.dart';
import 'package:training_example/features/setting/widgets/drop_down_button.dart';
import 'package:training_example/models/vn_address/province.dart';
import 'package:training_example/repositories/vn_address_repository.dart';
import 'package:training_example/translations/locale_keys.g.dart';
import 'package:training_example/utils/snackbar_hepler.dart';

import '../../../constants/fonts.dart';
import '../../../models/vn_address/commune.dart';
import '../../../models/vn_address/district.dart';

class ChangeAddressPage extends StatefulWidget {
  final Map<String, String?> address;

  const ChangeAddressPage({Key? key, required this.address}) : super(key: key);

  @override
  State<ChangeAddressPage> createState() => _ChangeAddressPageState();
}

class _ChangeAddressPageState extends State<ChangeAddressPage> {
  final TextEditingController _detailAddressController =
      TextEditingController();
  final VNAddressRepository addressRepository =
      getIt.get<VNAddressRepository>();

  final UserInfoBloc userInfoBloc = getIt.get<UserInfoBloc>();

  List<Province> provincesList = [];
  List<District> districtList = [];
  List<Commune> communeList = [];

  List<String> provincesNameList = [];
  List<String> districtNameList = [];
  List<String> communeNameList = [];

  String currentProvince = '';
  String currentDistrict = '';
  String currentCommune = '';
  String currentDetailAddress = '';

  @override
  void initState() {
    setupData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(LocaleKeys.changeAddress.tr(),
            style: const TextStyle(color: Colors.black54)),
        backgroundColor: Colors.white,
        elevation: 0.8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red, size: 24),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        actions: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                child: Text(LocaleKeys.done.tr().toUpperCase(),
                    style: const TextStyle(color: Colors.red)),
                onTap: () {
                  if (currentDistrict.isNotEmpty && currentCommune.isNotEmpty && _detailAddressController.text.isNotEmpty) {
                    userInfoBloc.add(UpdateAddressEvent(
                      province: currentProvince,
                      district: currentDistrict,
                      commune: currentCommune,
                      detail: _detailAddressController.text
                    ));
                    GoRouter.of(context).pop();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                LocaleKeys.chooseProvince.tr(),
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 5),
              DropDownButton(
                onChanged: (Object? value) {
                  changeProvince(value);
                },
                hint: LocaleKeys.chooseProvince.tr(),
                value: currentProvince,
                dropdownItems: provincesNameList,
                dropdownHeight: 250,
                buttonHeight: 60,
                buttonWidth: double.infinity,
                dropdownWidth: double.infinity,
                dropdownElevation: 0,
                icon: const Icon(Icons.arrow_drop_down_outlined, size: 30),
                scrollbarRadius: const Radius.circular(0),
              ),
              Visibility(
                visible: currentDistrict.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.chooseDistrict.tr(),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 5),
                    DropDownButton(
                      onChanged: (Object? value) {
                        changeDistrict(value);
                      },
                      hint: LocaleKeys.chooseDistrict.tr(),
                      value: currentDistrict,
                      dropdownItems: districtNameList,
                      buttonHeight: 60,
                      buttonWidth: double.infinity,
                      dropdownWidth: double.infinity,
                      dropdownElevation: 0,
                      icon:
                          const Icon(Icons.arrow_drop_down_outlined, size: 30),
                      scrollbarRadius: const Radius.circular(0),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: currentCommune.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.chooseCommune.tr(),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 5),
                    DropDownButton(
                      onChanged: (Object? value) {
                        changeCommune(value);
                      },
                      hint: LocaleKeys.chooseCommune.tr(),
                      value: currentCommune,
                      dropdownItems: communeNameList,
                      buttonHeight: 60,
                      buttonWidth: double.infinity,
                      dropdownWidth: double.infinity,
                      dropdownElevation: 0,
                      icon:
                          const Icon(Icons.arrow_drop_down_outlined, size: 30),
                      scrollbarRadius: const Radius.circular(0),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: currentCommune.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      LocaleKeys.detailAddressTitle.tr(),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      controller: _detailAddressController,
                      decoration: InputDecoration(
                        labelStyle:
                            const TextStyle(fontFamily: Fonts.muktaMedium),
                        hintText: LocaleKeys.inputDetail.tr(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void setupData() async {
    provincesNameList.insert(0, '-/-');
    districtNameList.insert(0, '-/-');
    communeNameList.insert(0, '-/-');

    setState(() {
      currentProvince = provincesNameList.first;
    });

    provincesList = await addressRepository.getAllProvinces();
    List<String> provincesName = provincesList.map((item) {
      return item.name;
    }).toList();
    setState(() {
      provincesNameList.addAll(provincesName);
    });

    if (widget.address['province']!.isNotEmpty) {
      setState(() {
        currentProvince = widget.address['province']!;
      });
      //setup district
      districtList = await addressRepository.getDistrictsOfProvince(
          idProvince: getProvinceId(
              provinceName: widget.address['province']!));
      List<String> districtsName = districtList.map((item) {
        return item.name;
      }).toList();
      setState(() {
        districtNameList.addAll(districtsName);
        currentDistrict = widget.address['district']!;
      });
      //setup commune
      communeList = await addressRepository.getCommunesOfDistrict(
          idDistrict: getDistrictId(districtName: widget.address['district']!));
      List<String> communesName = communeList.map((item) {
        return item.name;
      }).toList();
      setState(() {
        communeNameList.addAll(communesName);
        currentCommune = widget.address['commune']!;
      });
      //setup detail address
      setState(() {
        _detailAddressController.text = widget.address['detailAddress']!;
      });
    } else {
      setState(() {
        currentProvince = provincesNameList.first;
        currentDistrict = '';
        currentCommune = '';
        currentDetailAddress = '';
      });
    }
  }

  String getProvinceId(
      {required String provinceName}) {
    String id = '';
    for (Province item in provincesList) {
      if (item.name == provinceName) {
        id = item.idProvince;
        break;
      }
    }
    return id;
  }

  String getDistrictId(
      {required String districtName}) {
    String id = '';
    for (District item in districtList) {
      if (item.name == districtName) {
        id = item.idDistrict;
        break;
      }
    }
    return id;
  }

  void changeProvince(Object? value) async {
    String choseProvince = value as String;
    if (value == provincesNameList.first) {
      return;
    }
    currentProvince = choseProvince;
    currentDistrict = districtNameList.first;
    currentCommune = '';
    _detailAddressController.clear();

    //get districts by chose province
    List<District> districts = await addressRepository.getDistrictsOfProvince(
        idProvince: getProvinceId(
            provinceName: choseProvince));
    List<String> districtsName = districts.map((item) {
      return item.name;
    }).toList();

    setState(() {
      districtList = districts;
      districtNameList.removeRange(1, districtNameList.length);
      districtNameList.addAll(districtsName);
    });
  }

  void changeDistrict(Object? value) async {
    String choseDistrict = value as String;
    if (value == districtNameList.first) {
      return;
    }
    currentDistrict = choseDistrict;
    currentCommune = communeNameList.first;
    _detailAddressController.clear();
    //get districts by chose province
    List<Commune> communes = await addressRepository.getCommunesOfDistrict(
        idDistrict: getDistrictId(
            districtName: choseDistrict));
    List<String> communesName = communes.map((item) {
      return item.name;
    }).toList();

    setState(() {
      communeList = communes;
      communeNameList.removeRange(1, communeNameList.length);
      communeNameList.addAll(communesName);
    });
  }

  void changeCommune(Object? value) {
    String choseCommune = value as String;
    setState(() {
      currentCommune = choseCommune;
      _detailAddressController.text = '';
    });
  }
}
