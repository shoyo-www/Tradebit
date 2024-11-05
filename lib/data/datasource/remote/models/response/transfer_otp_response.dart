import 'dart:convert';

TransferOtpResponse transferOtpResponseFromJson(String str) => TransferOtpResponse.fromJson(json.decode(str));


class TransferOtpResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  TransferOtpResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory TransferOtpResponse.fromJson(Map<String, dynamic> json) => TransferOtpResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final String? email;
  final String? mobile;
  final String? otpType;
  final String? sendType;
  final bool? google2Fa;
  final DateTime? expiredAt;

  Data({
    this.email,
    this.mobile,
    this.otpType,
    this.sendType,
    this.expiredAt,
    this.google2Fa
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    email: json["email"],
    mobile: json["mobile"],
    otpType: json["otp_type"],
    sendType: json["send_type"],
    google2Fa: json["google2fa"],
    expiredAt: json["expired_at"] == null ? null : DateTime.parse(json["expired_at"]),
  );

}
