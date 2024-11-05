import 'dart:convert';

String verifyMobileRequestToJson(VerifyMobileRequest data) => json.encode(data.toJson());

class VerifyMobileRequest {
  final String type;
  final String mobile;
  final String countryCode;
  final String countryCallingCode;

  VerifyMobileRequest({
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
