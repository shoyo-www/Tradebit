import 'dart:convert';

String bindEmailRequestToJson(BindEmailRequest data) => json.encode(data.toJson());

class BindEmailRequest {
  final String? mobileVcode;
  final String? email;
  final String? emailVcode;
  final String? googleCode;

  BindEmailRequest({
    this.mobileVcode,
    this.email,
    this.emailVcode,
    this.googleCode
  });

  Map<String, dynamic> toJson() => {
    "mobile_vcode": mobileVcode,
    "email": email,
    "email_vcode": emailVcode,
    "google_vcode" : googleCode
  };
}




String bindMobileRequestToJson(BindMobileRequest data) => json.encode(data.toJson());

class BindMobileRequest {
  final String? emailVcode;
  final String? mobileVcode;
  final dynamic googleVcode;
  final String? mobile;
  final String? countryCode;
  final String? countryCallingCode;

  BindMobileRequest({
    this.emailVcode,
    this.mobileVcode,
    this.googleVcode,
    this.mobile,
    this.countryCode,
    this.countryCallingCode,
  });


  Map<String, dynamic> toJson() => {
    "email_vcode": emailVcode,
    "mobile_vcode": mobileVcode,
    "google_vcode": googleVcode,
    "mobile": mobile,
    "country_code": countryCode,
    "country_calling_code": countryCallingCode,
  };
}

