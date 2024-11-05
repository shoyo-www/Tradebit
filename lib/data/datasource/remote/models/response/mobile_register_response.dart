
import 'dart:convert';

RegisterMobileResponse registerMobileResponseFromJson(String str) => RegisterMobileResponse.fromJson(json.decode(str));

class RegisterMobileResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  RegisterMobileResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory RegisterMobileResponse.fromJson(Map<String, dynamic> json) => RegisterMobileResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );
}

class Data {
  final String? mobile;
  final String? countryCode;
  final String? countryCallingCode;
  final String? otpType;
  final String? sendType;
  final DateTime? expiredAt;
  final String? token;

  Data({
    this.mobile,
    this.countryCode,
    this.countryCallingCode,
    this.otpType,
    this.sendType,
    this.expiredAt,
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    mobile: json["mobile"],
    countryCode: json["country_code"],
    countryCallingCode: json["country_calling_code"],
    otpType: json["otp_type"],
    sendType: json["send_type"],
    expiredAt: json["expired_at"] == null ? null : DateTime.parse(json["expired_at"]),
    token: json["token"],
  );

}
