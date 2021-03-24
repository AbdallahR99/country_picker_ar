// To parse this JSON data, do
//
//     final countryPicker = countryPickerFromMap(jsonString);

import 'dart:convert';

List<CountryInfo> countryPickerFromMap(List<Map<String, String>> str) =>
    List<CountryInfo>.from(str.map((x) => CountryInfo.fromMap(x)));

String countryPickerToMap(List<CountryInfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class CountryInfo {
  CountryInfo({
    this.name,
    this.code,
    this.dialCode,
    this.nameEn,
    this.nameAr,
    this.flagUri,
  });

  String? name;
  String? code;
  String? dialCode;
  String? nameEn;
  String? nameAr;
  String? flagUri;

  factory CountryInfo.fromMap(Map<String, String> json) => CountryInfo(
        name: json["name"],
        code: json["code"],
        dialCode: json["dial_code"],
        nameEn: json["nameEn"] == null ? null : json["nameEn"],
        nameAr: json["nameAr"] == null ? null : json["nameAr"],
        flagUri: 'flags/${(json['code']?.toLowerCase() ?? "")}.png',
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "code": code,
        "dial_code": dialCode,
        "nameEn": nameEn == null ? null : nameEn,
        "nameAr": nameAr == null ? null : nameAr,
      };

  @override
  String toString() => "$dialCode";

  String toLongString() => "$dialCode ${toCountryStringOnly()}";

  String toCountryStringOnly() {
    return '$_cleanName';
  }

  String? get _cleanName {
    return name?.replaceAll(RegExp(r'[[\]]'), '').split(',').first;
  }
}
