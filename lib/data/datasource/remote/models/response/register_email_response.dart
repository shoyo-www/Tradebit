import 'dart:convert';

RegisterEmailResponse registerEmailResponseFromJson(String str) => RegisterEmailResponse.fromJson(json.decode(str));


class RegisterEmailResponse {
  final String? statusCode;
  final String? statusText;
  final String? message;
  final Data? data;

  RegisterEmailResponse({
    this.statusCode,
    this.statusText,
    this.message,
    this.data,
  });

  factory RegisterEmailResponse.fromJson(Map<String, dynamic> json) => RegisterEmailResponse(
    statusCode: json["status_code"],
    statusText: json["status_text"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

}

class Data {
  final String? email;
  final String? otpType;
  final String? sendType;
  final DateTime? expiredAt;
  final String? token;

  Data({
    this.email,
    this.otpType,
    this.sendType,
    this.expiredAt,
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    email: json["email"],
    otpType: json["otp_type"],
    sendType: json["send_type"],
    expiredAt: json["expired_at"] == null ? null : DateTime.parse(json["expired_at"]),
    token: json["token"],
  );

}
