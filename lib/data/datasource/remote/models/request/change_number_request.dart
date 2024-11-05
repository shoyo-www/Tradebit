import 'dart:convert';

String changeNumberRequestToJson(ChangeNumberRequest data) => json.encode(data.toJson());

class ChangeNumberRequest {
  final String type;
  final String mobile;
  final String countryCode;
  final String countryCallingCode;

  ChangeNumberRequest({
    required this.type,
    required this.mobile,
    required this.countryCode,
    required this.countryCallingCode,
  });


  Map<String, dynamic> toJson() => {
    "type": type,
    "mobile": mobile,
    "country_code": countryCode,
    "country_calling_code": countryCallingCode,
  };
}
