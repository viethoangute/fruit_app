// ignore: camel_case_types

import 'package:easy_localization/easy_localization.dart';

import '../translations/locale_keys.g.dart';

class Constants {
  //Firebase login exceptions
  static const loginSuccess = 'login-success';
  static const wrongPassword = 'wrong-password';
  static const invalidEmail = 'invalid-email';
  static const userDisabled = 'user-disabled';
  static const userNotFound = 'user-not-found';
  static const errorOccurred = 'error-occurred';

  static const int userLoadingThreshold = 20;

  //Others
  static const defaultImageUrl = 'https://firebasestorage.googleapis.com/v0/b/trainingexample-f3dec.appspot.com/o/image_default.jpeg?alt=media&token=c7c67c80-9c10-4195-9f13-ac052febb1cc';

  static List<String> generalCategories = [
    'ORGANIC',
    'FRUIT',
    'VEGGIES',
    'GROCERY',
    'FRIDGE',
    'SEAFOOD',
  ];
}