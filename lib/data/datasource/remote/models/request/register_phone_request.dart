import 'dart:convert';


String registerMobileRequestToJson(RegisterMobileRequest data) => json.encode(data.toJson());

class RegisterMobileRequest {
  final String? countryCallingCode;
  final String? countryCode;
  final String? mobile;
  final String? password;
  final String? referral;
  final bool? terms;

  RegisterMobileRequest({
    this.countryCallingCode,
    this.countryCode,
    this.mobile,
    this.password,
    this.referral,
    this.terms,
  });

  Map<String, dynamic> toJson() => {
    "country_calling_code": countryCallingCode,
    "country_code": countryCode,
    "mobile": mobile,
    "password": password,
    "referral": referral,
    "terms": terms,
  };
}
