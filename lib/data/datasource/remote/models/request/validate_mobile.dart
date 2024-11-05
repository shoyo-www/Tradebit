import 'dart:convert';

String validateMobileProfileToJson(ValidateMobileProfile data) => json.encode(data.toJson());

class ValidateMobileProfile {
  final String email;
  final String mobile;
  final String otp;
  final String sendType;

  ValidateMobileProfile({
    required this.email,
    required this.mobile,
    required this.otp,
    required this.sendType,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "mobile": mobile,
    "otp": otp,
    "send_type": sendType,
  };
}
