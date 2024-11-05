import 'dart:convert';

ChangeNumberResponse changeNumberResponseFromJson(String str) => ChangeNumberResponse.fromJson(json.decode(str));

class ChangeNumberResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  ChangeNumberResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory ChangeNumberResponse.fromJson(Map<String, dynamic> json) => ChangeNumberResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final dynamic email;
  final String? mobile;
  final String? otpType;
  final String? sendType;
  final DateTime? expiredAt;
  final int? maxAttempt;
  final int? verifyMaxAttempt;
  final dynamic verifyLastAttemptAt;
  final dynamic lastAttemptAt;

  Data({
    this.email,
    this.mobile,
    this.otpType,
    this.sendType,
    this.expiredAt,
    this.maxAttempt,
    this.verifyMaxAttempt,
    this.verifyLastAttemptAt,
    this.lastAttemptAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    email: json["email"],
    mobile: json["mobile"],
    otpType: json["otp_type"],
    sendType: json["send_type"],
    expiredAt: json["expired_at"] == null ? null : DateTime.parse(json["expired_at"]),
    maxAttempt: json["max_attempt"],
    verifyMaxAttempt: json["verify_max_attempt"],
    verifyLastAttemptAt: json["verify_last_attempt_at"],
    lastAttemptAt: json["last_attempt_at"],
  );

}
