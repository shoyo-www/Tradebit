import 'dart:convert';
String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

class LoginRequest {
  String captchaResponse;
  String countryCallingCode;
  String countryCode;
  String email;
  String loginType;
  String mobile;
  String password;

  LoginRequest({
    required this.captchaResponse,
    required this.countryCallingCode,
    required this.countryCode,
    required this.email,
    required this.loginType,
    required this.mobile,
    required this.password,
  });


  Map<String, dynamic> toJson() => {
    "captcha_response": captchaResponse,
    "country_calling_code": countryCallingCode,
    "country_code": countryCode,
    "email": email,
    "loginType": loginType,
    "mobile": mobile,
    "password": password,
  };
}
