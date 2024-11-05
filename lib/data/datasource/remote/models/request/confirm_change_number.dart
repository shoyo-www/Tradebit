import 'dart:convert';

String confirmNumberRequestToJson(ConfirmNumberRequest data) => json.encode(data.toJson());

class ConfirmNumberRequest {
  final String emailVcode;
  final String mobileVcode;
  final String googleVcode;
  final String newCountryCallingCode;
  final String newCountryCode;
  final String newMobile;
  final String newMobileVcode;

  ConfirmNumberRequest({
    required this.emailVcode,
    required this.mobileVcode,
    required this.googleVcode,
    required this.newCountryCallingCode,
    required this.newCountryCode,
    required this.newMobile,
    required this.newMobileVcode,
  });

  Map<String, dynamic> toJson() => {
    "email_vcode": emailVcode,
    "mobile_vcode": mobileVcode,
    "google_vcode": googleVcode,
    "new_country_calling_code": newCountryCallingCode,
    "new_country_code": newCountryCode,
    "new_mobile": newMobile,
    "new_mobile_vcode": newMobileVcode,
  };
}
