import 'dart:convert';

ResendOtpResponse resendOtpResponseFromJson(String str) => ResendOtpResponse.fromJson(json.decode(str));

class ResendOtpResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  ResendOtpResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) => ResendOtpResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final String? email;
  final dynamic mobile;
  final String? otpType;
  final String? sendType;
  final DateTime? expiredAt;

  Data({
    this.email,
    this.mobile,
    this.otpType,
    this.sendType,
    this.expiredAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    email: json["email"],
    mobile: json["mobile"],
    otpType: json["otp_type"],
    sendType: json["send_type"],
    expiredAt: json["expired_at"] == null ? null : DateTime.parse(json["expired_at"]),
  );

}
