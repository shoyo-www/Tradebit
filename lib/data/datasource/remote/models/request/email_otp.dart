import 'dart:convert';

String bindEmailRequestToJson(BindEmailOtpRequest data) => json.encode(data.toJson());

class BindEmailOtpRequest {
  final String? type;
  final String? email;

  BindEmailOtpRequest({
    this.type,
    this.email,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "email": email,
  };
}


String bindMobileRequestToJson(BindMobileOtpRequest data) => json.encode(data.toJson());

class BindMobileOtpRequest {
  final String? type;
  final String? mobile;
  final String? countryCode;
  final String? countryCallingCode;

  BindMobileOtpRequest({
    this.type,
    this.mobile,
    this.countryCode,
    this.countryCallingCode,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "mobile": mobile,
    "country_code": countryCode,
    "country_calling_code": countryCallingCode,
  };
}